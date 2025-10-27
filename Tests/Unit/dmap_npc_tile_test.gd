extends GutTest


# Tests serialization and deserialization of tiles with `npc_tile` features
func test_npc_tile_serialization_roundtrip():
	var DMap = load("res://Scripts/Gamedata/DMap.gd")
	var map = DMap.new("test_map", "", null)
	var tile = {"id": "grass", "rotation": 0, "feature": {"type": "npc_tile", "rotation": 180}}
	map.levels[0] = [tile]
	var data = map.get_data()
	var map_loaded = DMap.new("test_map", "", null)
	map_loaded.set_data(data)
	var result = map_loaded.levels[0][0]
	assert_eq(result.feature.type, "npc_tile", "Expected npc_tile feature type")
	assert_eq(result.feature.rotation, 180, "Expected rotation 180")
