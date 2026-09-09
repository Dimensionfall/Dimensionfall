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
	var crater_floor: Vector3 = fixture.grid_to_world(15, 13, 0.5)
	fixture.assert_path_connects(hut, rim, "Research hut to crater rim")
	fixture.assert_path_crosses_levels(rim, crater_floor, "Crater descent", 0.5, 1.5)
	fixture.assert_path_crosses_levels(crater_floor, rim, "Crater ascent", 0.5, 1.5)


func _populate_camp_geometry() -> void:
	for x in range(0, 32):
		for z in range(0, 32):
			if not Rect2i(12, 8, 12, 12).has_point(Vector2i(x, z)):
				fixture.add_block(Vector3(x, 0, z))
	for x in range(12, 24):
		for z in range(8, 20):
			fixture.add_block(Vector3(x, -1, z))
	fixture.add_block(Vector3(12, 0, 13), "slope", 270)

	for x in range(3, 10):
		fixture.add_wall_obstacle(Vector3(x, 1, 9))
		fixture.add_wall_obstacle(Vector3(x, 1, 17))
	for z in range(10, 17):
		fixture.add_wall_obstacle(Vector3(3, 1, z))
		if z != 13:
			fixture.add_wall_obstacle(Vector3(9, 1, z))
