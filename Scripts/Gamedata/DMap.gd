class_name DMap
extends RefCounted

# There's a D in front of the class name to indicate this class only handles map data, nothing more
# This script is intended to be used inside the GameData autoload singleton
# This script handles data for one map. You can access it trough Gamedata.mods.by_id("Core").maps

# Example map data:
#{
#	"areas": [
#	{
#		"id": "base_layer",
#		"rotate_random": false,
#		"spawn_chance": 100,
#		"tiles": [
#			{ "id": "grass_plain_01", "count": 100 },
#			{ "id": "grass_dirt_00", "count": 15 }
#		],
#		"entities": []
#	},
#	{
#		"id": "sparse_trees",
#		"rotate_random": true,
#		"spawn_chance": 30,
#		"tiles": [
#			{ "id": "null", "count": 1000 }
#		],
#		"entities": [
#			{ "id": "Tree_00", "type": "furniture", "count": 1 },
#			{ "id": "WillowTree_00", "type": "furniture", "count": 1 }
#		]
#	},
#	{
#		"id": "generic_field_finds",
#		"rotate_random": false,
#		"spawn_chance": 50,
#		"tiles": [
#			{ "id": "null", "count": 500 }
#		],
#		"entities": [
#			{ "id": "generic_field_finds", "type": "itemgroup", "count": 1 }
#		]
#	}
#	],
#	"categories": ["Field", "Plains"],
#	"connections": {
#	"north": "ground",
#	"south": "ground",
#	"east": "ground",
#	"west": "ground"
#	},
#	"description": "A simple and vast field covered with green grass, perfect for beginners.",
#	"id": "field_grass_basic_00",
#	"levels": [
#		[], [], [], [], [], [], [], [], [], [],
#	[
#		{
#		"id": "grass_medium_dirt_01",
#		"rotation": 180,
#		"areas": [
#			{ "id": "base_layer", "rotation": 0 },
#			{ "id": "sparse_trees", "rotation": 0 },
#			{ "id": "generic_field_finds", "rotation": 0 }
#		]
#		},
#		{
#		"id": "grass_plain_01",
#		"rotation": 90,
#		"areas": [
#			{ "id": "base_layer", "rotation": 0 },
#			{ "id": "sparse_trees", "rotation": 0 },
#			{ "id": "generic_field_finds", "rotation": 0 }
#		]
#		}
#	]
#	],
#	"mapheight": 32,
#	"mapwidth": 32,
#	"name": "Basic Grass Field"
#	"weight": 1000
#}

var id: String = "":
	set(newid):
		id = newid.replace(".json", "")  # In case the filename is passed, we remove json
var name: String = ""
var description: String = ""
var categories: Array = []  # example: "categories": ["Buildings","Urban","City"]
var weight: int = 1000
var mapwidth: int = 32
var mapheight: int = 32
var levels: Array = [
	[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []
]
var areas: Array = []
var sprite: Texture = null
# Variable to store connections. For example: {"south": "road","west": "ground"} default to ground
var connections: Dictionary = {
	"north": "ground", "east": "ground", "south": "ground", "west": "ground"
}
var dataPath: String
var parent: DMaps


# The area that may be present on the map
# TODO: Implement this into the script
class area:
	var entities: Array = []
	var id: String = ""
	var rotate_random: bool = false
	var spawn_chance: int = 100
	var tiles: Array = []


# Definition of a tile on the map, in one of the levels
# TODO: Implement this into the script
class maptile:
	# Only a reference to an area, not an instance of an area. Can have "id" and "rotation"
	var areas: Array = []
	var id: String = ""  # The id of the tile
	var rotation: int = 0
	# Unified feature structure for this tile. Holds furniture, mobs, mobgroups
	# and itemgroups in a single dictionary.
	var feature: Dictionary = {}


func _init(newid: String, newdataPath: String, myparent: DMaps):
	id = newid
	dataPath = newdataPath
	parent = myparent


func set_data(newdata: Dictionary) -> void:
	name = newdata.get("name", "")
	description = newdata.get("description", "")
	categories = newdata.get("categories", [])
	weight = newdata.get("weight", 1000)
	mapwidth = newdata.get("mapwidth", 32)
	mapheight = newdata.get("mapheight", 32)
	# Convert legacy level data to the unified feature dictionary
	levels = _convert_levels_legacy_to_feature(
		newdata.get(
			"levels",
			[[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
		)
	)
	areas = newdata.get("areas", [])
	connections = newdata.get("connections", {})  # Set connections from data if present


func get_data() -> Dictionary:
	var mydata: Dictionary = {}
	mydata["id"] = id
	mydata["name"] = name
	mydata["description"] = description
	if not categories.is_empty():
		mydata["categories"] = categories
	mydata["weight"] = weight
	mydata["mapwidth"] = mapwidth
	mydata["mapheight"] = mapheight
	# Strip empty feature entries when saving
	mydata["levels"] = _convert_levels_feature_for_save(levels)
	if not areas.is_empty():
		mydata["areas"] = areas
	if not connections.is_empty():  # Omit connections if empty
		mydata["connections"] = connections
	return mydata


func load_data_from_disk():
	set_data(Helper.json_helper.load_json_dictionary_file(get_file_path()))
	sprite = load(get_sprite_path())


func save_data_to_disk() -> void:
	var map_data_json = JSON.stringify(get_data().duplicate(), "\t")
	Helper.json_helper.write_json_file(get_file_path(), map_data_json)


func get_filename() -> String:
	return id + ".json"


func get_file_path() -> String:
	return dataPath + get_filename()


func get_sprite_path() -> String:
	return get_file_path().replace(".json", ".png")


# This will remove this map from the tacticalmap in every mod that has it.
func remove_self_from_tacticalmap(tacticalmap_id: String) -> void:
	var all_results: Array = Gamedata.mods.get_all_content_by_id(
		DMod.ContentType.TACTICALMAPS, tacticalmap_id
	)
	if all_results.size() > 0:
		for result: DTacticalmap in all_results:
			result.remove_chunk_by_mapid(id)
	else:
		print("No content found.")


# A map is being deleted. Remove all references to this map
func delete_files():
	var json_file_path = get_file_path()
	var png_file_path = get_sprite_path()
	Helper.json_helper.delete_json_file(json_file_path)
	# Use DirAccess to check and delete the PNG file
	var dir = DirAccess.open(dataPath)
	if dir.file_exists(png_file_path):
		dir.remove(id + ".png")
		dir.remove(id + ".png.import")


# We remove ourselves from the filesystem and the parent maplist
# After this, the map is deleted from the current mod that the parent maplist is a part of
# If no copies of this map remain in any mod, we have to remove all references.
func delete():
	delete_files()
	parent.erase_id(id)
	# Check to see if any mod has a copy of this map. if one or more remain, we can keep references
	# Otherwise, the last copy was removed and we need to remove references
	var all_results: Array = Gamedata.mods.get_all_content_by_id(DMod.ContentType.MAPS, id)
	if all_results.size() > 0:
		return

	var myreferences: Dictionary = parent.references.get(id, {})
	# Remove this map from the tacticalmaps in this map's references
	for ref in myreferences.get("tacticalmaps", []):
		remove_self_from_tacticalmap(ref)

	# Remove this map from the overmapareas in this map's references
	for ref in myreferences.get("overmapareas", []):
		var myareas: Array = Gamedata.mods.get_all_content_by_id(DMod.ContentType.OVERMAPAREAS, ref)
		if myareas.is_empty():
			print_debug("Missing overmap area '" + ref + "' while deleting map '" + id + "'")
		for area: DOvermaparea in myareas:
			area.remove_map_from_all_regions(id)

		# Remove this map from NPC spawn lists
	for npc_id in myreferences.get("npcs", []):
		var npcs: Array = Gamedata.mods.get_all_content_by_id(DMod.ContentType.NPCS, npc_id)
		if npcs.is_empty():
			print_debug("Missing NPC '" + npc_id + "' while deleting map '" + id + "'")
		for npc: DNpc in npcs:
			npc.remove_map_from_spawn_maps(id)

	# Remove this map from quests
	for quest_id in myreferences.get("quests", []):
		var quests: Array = Gamedata.mods.get_all_content_by_id(DMod.ContentType.QUESTS, quest_id)
		if quests.is_empty():
			print_debug("Missing quest '" + quest_id + "' while deleting map '" + id + "'")
		for quest: DQuest in quests:
			quest.remove_steps_by_map(id)

	remove_my_reference_from_all_entities()

	# Remove entry from references.json and save
	parent.references.erase(id)
	Gamedata.mods.save_references(parent)


func remove_my_reference_from_all_entities() -> void:
	# Collect unique entities from mapdata
	var entities = collect_unique_entities(DMap.new(id, dataPath, parent))
	var unique_entities: Dictionary = entities["new_entities"]

	# Remove references for feature entries
	for feature in unique_entities.get("features", []):
		match feature["type"]:
			"furniture":
				Gamedata.mods.remove_reference(
					DMod.ContentType.FURNITURES, feature["id"], DMod.ContentType.MAPS, id
				)
			"mob":
				Gamedata.mods.remove_reference(
					DMod.ContentType.MOBS, feature["id"], DMod.ContentType.MAPS, id
				)
			"mobgroup":
				Gamedata.mods.remove_reference(
					DMod.ContentType.MOBGROUPS, feature["id"], DMod.ContentType.MAPS, id
				)
			"itemgroup":
				Gamedata.mods.remove_reference(
					DMod.ContentType.ITEMGROUPS, feature["id"], DMod.ContentType.MAPS, id
				)

	# Remove tile references
	for tile_id in unique_entities.get("tiles", []):
		Gamedata.mods.remove_reference(DMod.ContentType.TILES, tile_id, DMod.ContentType.MAPS, id)


# Function to update map entity references when a map's data changes
func data_changed(oldmap: DMap):
	# Collect unique entities from both new and old data
	var entities = collect_unique_entities(oldmap)
	var new_entities: Dictionary = entities["new_entities"]
	var old_entities: Dictionary = entities["old_entities"]

	# Add references for new features
	for feature in new_entities.get("features", []):
		match feature["type"]:
			"furniture":
				Gamedata.mods.add_reference(
					DMod.ContentType.FURNITURES, feature["id"], DMod.ContentType.MAPS, id
				)
			"mob":
				Gamedata.mods.add_reference(
					DMod.ContentType.MOBS, feature["id"], DMod.ContentType.MAPS, id
				)
			"mobgroup":
				Gamedata.mods.add_reference(
					DMod.ContentType.MOBGROUPS, feature["id"], DMod.ContentType.MAPS, id
				)
			"itemgroup":
				Gamedata.mods.add_reference(
					DMod.ContentType.ITEMGROUPS, feature["id"], DMod.ContentType.MAPS, id
				)

	# Add references for new tiles
	for tile_id in new_entities.get("tiles", []):
		Gamedata.mods.add_reference(DMod.ContentType.TILES, tile_id, DMod.ContentType.MAPS, id)

	# Remove references for entities not present in new data
	for feature in old_entities.get("features", []):
		if not _feature_exists(new_entities.get("features", []), feature):
			match feature["type"]:
				"furniture":
					Gamedata.mods.remove_reference(
						DMod.ContentType.FURNITURES, feature["id"], DMod.ContentType.MAPS, id
					)
				"mob":
					Gamedata.mods.remove_reference(
						DMod.ContentType.MOBS, feature["id"], DMod.ContentType.MAPS, id
					)
				"mobgroup":
					Gamedata.mods.remove_reference(
						DMod.ContentType.MOBGROUPS, feature["id"], DMod.ContentType.MAPS, id
					)
				"itemgroup":
					Gamedata.mods.remove_reference(
						DMod.ContentType.ITEMGROUPS, feature["id"], DMod.ContentType.MAPS, id
					)

	for tile_id in old_entities.get("tiles", []):
		if not new_entities.get("tiles", []).has(tile_id):
			Gamedata.mods.remove_reference(
				DMod.ContentType.TILES, tile_id, DMod.ContentType.MAPS, id
			)


# Function to collect unique entities from each level in newdata and olddata
func collect_unique_entities(oldmap: DMap) -> Dictionary:
	var new_entities = {"features": [], "tiles": []}
	var old_entities = {"features": [], "tiles": []}

	# Collect entities from newdata
	for level in levels:
		add_entities_to_set(level, new_entities)

	# Collect entities from olddata
	for level in oldmap.levels:
		add_entities_to_set(level, old_entities)

	# Collect entities from newdata
	for myarea in areas:
		add_entities_in_area_to_set(myarea, new_entities)

	# Collect entities from olddata
	for myarea in oldmap.areas:
		add_entities_in_area_to_set(myarea, old_entities)

	return {"new_entities": new_entities, "old_entities": old_entities}


# Helper function to add entities to the respective sets
func add_entities_in_area_to_set(myarea: Dictionary, entity_set: Dictionary):
	if myarea.has("entities"):
		for entity in myarea["entities"]:
			var feature_type: String = entity.get("type", "")
			match feature_type:
				"mob", "mobgroup", "furniture":
					_add_feature_to_set(entity_set, feature_type, entity.get("id", ""))
				"itemgroup":
					_add_feature_to_set(entity_set, "itemgroup", entity.get("id", ""))

	if myarea.has("tiles"):
		for tile in myarea["tiles"]:
			# The "null" tile in areas is used to control propoprtions and is not really an entity
			if not entity_set["tiles"].has(tile["id"]) and not tile["id"] == "null":
				entity_set["tiles"].append(tile["id"])


# Helper function to add entities to the respective sets
func add_entities_to_set(level: Array, entity_set: Dictionary):
	for entity in level:
		if entity.has("feature"):
			var feature: Dictionary = entity["feature"]
			var ftype: String = feature.get("type", "")
			match ftype:
				"mob", "mobgroup", "furniture":
					var fid: String = feature.get("id", "")
					if fid != "":
						_add_feature_to_set(entity_set, ftype, fid)
					if feature.has("itemgroups"):
						for itemgroup in feature["itemgroups"]:
							_add_feature_to_set(entity_set, "itemgroup", itemgroup)
				"itemgroup":
					for itemgroup in feature.get("itemgroups", []):
						_add_feature_to_set(entity_set, "itemgroup", itemgroup)


# Helper to add a feature id to the entity_set if it doesn't exist yet
func _add_feature_to_set(entity_set: Dictionary, ftype: String, fid: String) -> void:
	if fid == "":
		return
	for existing in entity_set["features"]:
		if existing["type"] == ftype and existing["id"] == fid:
			return
	entity_set["features"].append({"type": ftype, "id": fid})


# Helper to check if a feature entry exists in a list
func _feature_exists(feature_list: Array, feature: Dictionary) -> bool:
	for f in feature_list:
		if (
			f.get("type", "") == feature.get("type", "")
			and f.get("id", "") == feature.get("id", "")
		):
			return true
	return false


# Removes all instances of the provided entity from the map
# entity_type can be "tile" or a feature type ("furniture", "mob", "mobgroup", "itemgroup")
# entity_id is the id of the tile or feature
func remove_entity_from_map(entity_type: String, entity_id: String) -> void:
	# Translate the type to the actual key that we need
	if entity_type == "tile":
		entity_type = "id"
	remove_entity_from_levels(entity_type, entity_id)
	erase_entity_from_areas(entity_type, entity_id)
	save_data_to_disk()


# Removes all instances of the provided entity from the levels
# entity_type can be "tile" or a feature type ("furniture", "mob", "mobgroup", "itemgroup")
# entity_id is the id of the tile or feature
func remove_entity_from_levels(entity_type: String, entity_id: String) -> void:
	for level in levels:
		for entity_index in range(level.size()):
			var entity: Dictionary = level[entity_index]

			match entity_type:
				"id":
					if entity.get("id", "") == entity_id:
						level[entity_index] = {}
				"furniture", "mob", "mobgroup":
					if (
						entity.get("feature", {}).get("type", "") == entity_type
						and entity["feature"].get("id", "") == entity_id
					):
						entity.erase("feature")
				"itemgroup":
					if entity.has("feature"):
						var feature = entity["feature"]
						if feature.get("type", "") == "itemgroup":
							var groups: Array = feature.get("itemgroups", [])
							if groups.has(entity_id):
								groups.erase(entity_id)
								if groups.is_empty():
									entity.erase("feature")
								else:
									feature["itemgroups"] = groups
						elif feature.get("type", "") == "furniture" and feature.has("itemgroups"):
							var groups_f: Array = feature["itemgroups"]
							if groups_f.has(entity_id):
								groups_f.erase(entity_id)
								if groups_f.is_empty():
									feature.erase("itemgroups")


# Function to erase an entity from every area
func erase_entity_from_areas(entity_type: String, entity_id: String) -> void:
	for myarea in areas:
		match entity_type:
			"tile":
				if myarea.has("tiles"):
					myarea["tiles"] = myarea["tiles"].filter(
						func(tile): return tile["id"] != entity_id
					)
			"furniture", "mob", "mobgroup", "itemgroup":
				if myarea.has("entities"):
					myarea["entities"] = myarea["entities"].filter(
						func(entity):
							return not (entity["type"] == entity_type and entity["id"] == entity_id)
					)


# Function to remove a area from mapData.areas by its id
func remove_area(area_id: String) -> void:
	# Iterate through the areas array to find and remove the area by id
	for i in range(areas.size()):
		if areas[i]["id"] == area_id:
			areas.erase(areas[i])
			break


# Function to set a connection type for a specific direction
func set_connection(direction: String, value: String) -> void:
	# Ensure the connections dictionary has an entry for the specified direction (e.g., "north", "south").
	if not connections.has(direction):
		connections[direction] = "ground"  # Default to "ground" if not already set.

	# Assign the provided connection type (e.g., "road", "ground") to the specified direction.
	connections[direction] = value


# Function to get a connection type for a specific direction, returning "ground" if any key is missing
func get_connection(direction: String) -> String:
	# Return "ground" if connections dictionary is empty or the direction is not found.
	if connections.is_empty() or not connections.has(direction):
		return "ground"

	# Return the connection type for the specified direction (e.g., "road" or "ground").
	return connections[direction]


# --- Helper functions for tile feature conversion ---


# Converts legacy tile dictionaries to use the `feature` dictionary structure
# A legacy tile looks like this:
#	{
#		"areas": [
#			{
#				"id": "floor_bedroom",
#				"rotation": 0.0
#			}
#		],
#		"furniture": {
#			"id": "door_wood",
#			"rotation": 180.0
#		},
#		"id": "floor_wood_boards_05",
#		"rotation": 180.0
#	},
func _legacy_tile_to_feature(tile: Dictionary) -> Dictionary:
	if tile.has("feature"):
		return tile

	if tile.has("furniture"):
		var f = tile["furniture"]
		tile["feature"] = {
			"type": "furniture", "id": f.get("id", ""), "rotation": f.get("rotation", 0)
		}
		if f.has("itemgroups"):
			tile["feature"]["itemgroups"] = f["itemgroups"]
		tile.erase("furniture")

	elif tile.has("mob"):
		var m = tile["mob"]
		tile["feature"] = {"type": "mob", "id": m.get("id", ""), "rotation": m.get("rotation", 0)}
		tile.erase("mob")

	elif tile.has("mobgroup"):
		var mg = tile["mobgroup"]
		tile["feature"] = {
			"type": "mobgroup", "id": mg.get("id", ""), "rotation": mg.get("rotation", 0)
		}
		tile.erase("mobgroup")

	elif tile.has("itemgroups"):
		var groups = tile["itemgroups"]
		tile["feature"] = {
			"type": "itemgroup", "itemgroups": groups, "rotation": tile.get("rotation", 0)  # No per-itemgroup rotation, fallback to tile
		}
		tile.erase("itemgroups")

	return tile


# Applies legacy conversion to all tiles within all levels
func _convert_levels_legacy_to_feature(raw_levels: Array) -> Array:
	var converted: Array = []
	for level in raw_levels:
		var new_level: Array = []
		for tile in level:
			var t: Dictionary = tile.duplicate()
			new_level.append(_legacy_tile_to_feature(t))
		converted.append(new_level)
	return converted


# Prepares levels for saving by omitting empty `feature` entries
func _convert_levels_feature_for_save(in_levels: Array) -> Array:
	var result: Array = []
	for level in in_levels:
		var new_level: Array = []
		for tile in level:
			var t: Dictionary = tile.duplicate()
			if t.has("feature") and t["feature"].is_empty():
				t.erase("feature")
			new_level.append(t)
		result.append(new_level)
	return result
