extends GutTest


class BrushComposerStub:
	extends Control
	var brush

	func get_random_brush():
		return brush

	func get_tilerotation(rotation):
		return rotation

	func get_itemgroup_entity_ids():
		return []

	func get_selected_area_name():
		return ""


class TileStub:
	extends Control
	var updated_data = null

	func update_display(data, _area):
		updated_data = data


class MapStub:
	extends Node
	var levels = [[{}]]


func test_apply_paint_to_tile_sets_npc_tile_feature():
	var grid = load("res://Scenes/ContentManager/Mapeditor/Scripts/GridContainer.gd").new()
	var tile = TileStub.new()
	var tile_parent = Control.new()
	tile_parent.add_child(tile)
	var map = MapStub.new()
	map.levels[0][0] = {"feature": {"type": "mob", "id": "zombie"}}
	var map_editor = Control.new()
	map_editor.currentMap = map
	grid.mapEditor = map_editor
	grid.currentLevel = 0
	var brush = Control.new()
	brush.entityType = "npc_tile"
	brush.entityID = "npc_tile"
	var composer = BrushComposerStub.new()
	composer.brush = brush
	grid.brushcomposer = composer
	grid.apply_paint_to_tile(tile, brush, 90)
	var result = map.levels[0][0]
	assert_eq(result.feature.type, "npc_tile", "Expected npc_tile feature type")
	assert_eq(result.feature.rotation, 90, "Expected rotation 90")
	assert_false(result.feature.has("id"), "npc_tile should not have id")
