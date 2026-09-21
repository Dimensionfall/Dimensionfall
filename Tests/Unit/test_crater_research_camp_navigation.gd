extends GutTest


const MapNavigationFixture = preload("res://Tests/Unit/helpers/map_navigation_fixture.gd")


var fixture


func before_each() -> void:
	fixture = MapNavigationFixture.new(self)
	await fixture.setup()


func after_each() -> void:
	await fixture.teardown()


func test_crater_research_camp_connects_hut_rim_and_crater_floor() -> void:
	await fixture.begin_geometry()
	_populate_camp_geometry()
	assert_true(await fixture.bake(), "The crater research camp navigation should finish baking.")

	var hut: Vector3 = fixture.grid_to_world(8, 13, 1.5)
	var rim: Vector3 = fixture.grid_to_world(11, 13, 1.5)
	var crater_floor: Vector3 = fixture.grid_to_world(19, 14, -2.5)
	fixture.assert_path_connects(hut, rim, "Research hut to crater rim")
	fixture.assert_path_connects(rim, crater_floor, "Crater descent")
	fixture.assert_path_connects(crater_floor, rim, "Crater ascent")
	for depth in range(1, 4):
		var terrace: Vector3 = fixture.grid_to_world(11 + depth * 2, 13, 1.5 - depth)
		fixture.assert_path_connects(rim, terrace, "Surface to terrace %s" % depth)
		fixture.assert_path_connects(terrace, rim, "Terrace %s to surface" % depth)
	var map_data: Dictionary = JSON.parse_string(
		FileAccess.get_file_as_string("res://Mods/Dimensionfall/Maps/crater_research_camp.json")
	)
	for level_index in range(6, 10):
		for index in range(1024):
			var cell: Dictionary = map_data["levels"][level_index][index]
			if cell.is_empty() or not map_data["levels"][level_index + 1][index].is_empty():
				continue
			if cell["id"] == "rock_slope_00":
				continue
			var point: Vector3 = fixture.grid_to_world(
				index % 32, floori(index / 32.0), level_index - 8.5
			)
			fixture.assert_path_connects(point, rim, "Return from floor cell %s:%s" % [level_index, index])
			fixture.assert_path_connects(rim, point, "Reach floor cell %s:%s" % [level_index, index])


func _populate_camp_geometry() -> void:
	var map_data: Dictionary = JSON.parse_string(
		FileAccess.get_file_as_string("res://Mods/Dimensionfall/Maps/crater_research_camp.json")
	)
	for level_index in range(6, 11):
		var cells: Array = map_data["levels"][level_index]
		for index in range(cells.size()):
			var cell: Dictionary = cells[index]
			if not cell.has("id"):
				continue
			var shape := "slope" if cell["id"] == "rock_slope_00" else "cube"
			fixture.add_block(
				Vector3(index % 32, level_index - 10, floori(index / 32.0)),
				shape,
				int(cell.get("rotation", 0))
			)

	for x in range(3, 10):
		fixture.add_wall_obstacle(Vector3(x, 1, 9))
		fixture.add_wall_obstacle(Vector3(x, 1, 17))
	for z in range(10, 17):
		fixture.add_wall_obstacle(Vector3(3, 1, z))
		if z != 13:
			fixture.add_wall_obstacle(Vector3(9, 1, z))
