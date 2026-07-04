extends GutTest

# Tests the sanitization logic in DMap.get_data() for corrupt tiles.
func test_dmap_tile_sanitization():
	var DMap = load("res://Scripts/Gamedata/DMap.gd")
	# We use null for DMap parent as it's not used by the sanitization logic being tested here
	var map = DMap.new("test_sanitization_map", "/tmp/", null)
	
	# Setup dimensions: 32x32 = 1024 tiles (as per task requirements)
	map.mapwidth = 32
	map.mapheight = 32
	
	# Level 0 will contain the test cases
	var level_0: Array = []
	
	# --- TEST CASE: VALID TILE ---
	# Should remain unchanged
	var valid_tile = {"id": "floor_wood_boards_00", "rotation": 90}
	level_0.append(valid_tile.duplicate())
	
	# --- TEST CASE: MISSING ID KEY ---
	# Should be replaced by {}
	var missing_id_tile = {"rotation": 90}
	level_0.append(missing_id_tile.duplicate())
	
	# --- TEST CASE: EMPTY STRING ID ---
	# Should be replaced by {}
	var empty_id_tile = {"id": "", "rotation": 45}
	level_0.append(empty_id_tile.duplicate())
	
	# --- TEST CASE: WHITESPACE-ONLY ID ---
	# Should be replaced by {}
	var whitespace_id_tile = {"id": "   ", "furniture": {"id": "lamp_standing"}}
	level_0.append(whitespace_id_tile.duplicate())
	
	# Fill the rest of the 1024 tiles with valid grass tiles to ensure total count remains unchanged
	var remaining_tiles = 1024 - level_0.size()
	for i in range(remaining_tiles):
		level_0.append({"id": "grass_plain_01", "rotation": 0})
		
	map.levels[0] = level_0
	
	# Perform data retrieval (triggering sanitization)
	var data = map.get_data()
	var retrieved_level = data["levels"][0]
	
	# --- ASSERTIONS ---
	
	# 1. Verify total count of tile entries remains unchanged
	assert_eq(retrieved_level.size(), 1024, "Total tile count should remain 1024")
	
	# 2. Verify valid tile remains identical
	var result_valid = retrieved_level[0]
	assert_eq(result_valid["id"], "floor_wood_boards_00", "Valid tile ID mismatch")
	assert_eq(result_valid["rotation"], 90, "Valid tile rotation mismatch")
	
	# 3. Verify missing id key is sanitized to {}
	var result_missing = retrieved_level[1]
	assert_true(result_missing.is_empty(), "Tile with missing ID should be an empty dictionary")
	
	# 4. Verify empty string id is sanitized to {}
	var result_empty = retrieved_level[2]
	assert_true(result_empty.is_empty(), "Tile with empty ID should be an empty dictionary")
	
	# 5. Verify whitespace-only id is sanitized to {}
	var result_whitespace = retrieved_level[3]
	assert_true(result_whitespace.is_empty(), "Tile with whitespace ID should be an empty dictionary")
	
	# 6. Verify a standard filled tile in the remainder works
	var result_filler = retrieved_level[4]
	assert_eq(result_filler["id"], "grass_plain_01", "Filler tile should remain unchanged")
