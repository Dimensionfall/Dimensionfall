extends GutTest


# Tests map_manager logging and overwriting of `npc_tile` features
func test_npc_tile_logged_and_overwritten():
	var MapManager = load("res://Scripts/Helper/map_manager.gd")
	var manager = MapManager.new()
	var tile = {
		"id": "base", "areas": [{"id": "area"}], "feature": {"type": "npc_tile", "rotation": 0}
	}
	var level = [tile]
	var map_data = {
		"areas":
		[
			{
				"id": "area",
				"tiles": [{"id": "base", "count": 1}],
				"entities": [{"id": "Tree_00", "type": "furniture", "count": 1}],
				"spawn_chance": 100,
				"rotate_random": false
			}
		],
		"levels": [level]
	}
	manager.npc_tile_log.clear()
	manager.apply_area_clusters_to_tiles(level, "area", map_data, 1, 1)
	assert_eq(manager.npc_tile_log.size(), 1, "Expected one npc_tile logged")
	var result_tile = level[0]
	assert_eq(result_tile.feature.type, "furniture", "npc_tile should be overwritten")
