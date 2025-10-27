In pull request #872, furniture and mobs and itemgroups were altered to fit inside a "feature" property in a tile. For example, this code processes the feature property of a tile:
```

# Function to process entities data and add them to result
func _process_entities_data(
	area_data: Dictionary, result: Dictionary, original_tile: Dictionary
) -> void:
	# Calculate the total count of tiles
	var tiles_data = area_data.get("tiles", [])
	var total_tiles_count: int = calculate_total_count(tiles_data)

	# Duplicate the entities_data and add the "None" entity
	var entities_data = area_data.get("entities", []).duplicate()
	# We add an extra item to the entities list
	# which will affect the proportion of entities that will spawn
	# If you have an area of grass with a grass tile with a count of 100
	# and a tree furniture with a count of 1, the entities_data will contain
	# the tree furniture with a count of 1 and the "None" with a count of 100
	# This results in the tree being picked every 1 in 100 tiles.
	entities_data.append({"id": "None", "type": "None", "count": total_tiles_count})

	var tile_area_rotation: int = get_tile_area_rotation(original_tile, area_data)

	# Pick an entity from the duplicated entities_data
	if not entities_data.is_empty():
		var selected_entity = pick_item_based_on_count(entities_data)
		if selected_entity["type"] != "None":
			var rotation = _get_random_rotation(area_data)
			if rotation == -1:
				rotation = tile_area_rotation

			# Store the selected entity in the unified feature dictionary
			result["feature"] = {
				"type": selected_entity["type"],
				"rotation": rotation,
			}
			match selected_entity["type"]:
				"furniture", "mob", "mobgroup":
					result.feature["id"] = selected_entity["id"]
				"itemgroup":
					result.feature["itemgroups"] = [selected_entity["id"]]
```

However, I forgot to update the `rotate_level_clockwise` function in `chunk.gd`. It still checks for `new_level_data[new_index].has("furniture")` but it should check for feature instead. The current issue is that furniture is not rotated along with the map right now, so the orientation is wrong. The goal of this feature is to update the `rotate_level_clockwise` function so that furniture is rotated. Also check other scripts that try to get or set information on a tile furniture property instead of the tile feature property.
