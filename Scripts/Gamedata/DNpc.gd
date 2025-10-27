class_name DNpc
extends RefCounted

# JSON fields for an NPC:
# {
#     "id": "hank",
#     "name": "Hank",
#     "description": "Friendly wanderer",
#     "sprite": "hank.png",
#     "health": 100
# }

var id: String
var name: String
var description: String
var spriteid: String
var sprite: Texture
var health: int = 100
var parent: DNpcs
var spawn_maps: Array = []


func _init(data: Dictionary, myparent: DNpcs):
	parent = myparent
	id = data.get("id", "")
	name = data.get("name", "")
	description = data.get("description", "")
	spriteid = data.get("sprite", "")
	health = data.get("health", 100)
	spawn_maps = data.get("spawn_maps", [])


func get_data() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"description": description,
		"sprite": spriteid,
		"health": health,
		"spawn_maps": spawn_maps
	}


# Persist this NPC to disk through the parent container
func save_to_disk():
	parent.save_npcs_to_disk()

# Remove a map from this NPC's spawn list
func remove_map_from_spawn_maps(map_id: String) -> void:
	spawn_maps = spawn_maps.filter(func(entry): return entry.get("id", entry) != map_id)
	save_to_disk()


# Data has changed; update the references
# This will make sure that when a map is deleted, it is also removed from the NPC spawn list
func changed(olddata: DNpc):
	var old_ids: Array = []
	for map_data in olddata.spawn_maps:
		old_ids.append(map_data.get("id", map_data.id))

	var new_ids: Array = []
	for map_data in spawn_maps:
		new_ids.append(map_data.get("id", map_data.id))

	# We let the previously added maps know that this NPC no longer references them
	for map_id in old_ids:
		if not new_ids.has(map_id):
			(
				Gamedata
				. mods
				. remove_reference(
					DMod.ContentType.MAPS,
					map_id,
					DMod.ContentType.NPCS,
					id,
				)
			)

	# We let the newly added maps know that this NPC references them
	for map_id in new_ids:
		(
			Gamedata
			. mods
			. add_reference(
				DMod.ContentType.MAPS,
				map_id,
				DMod.ContentType.NPCS,
				id,
			)
		)

	parent.save_npcs_to_disk()


# Delete handler - references to clean up
func delete():
	var all_results: Array = (
		Gamedata
		. mods
		. get_all_content_by_id(
			DMod.ContentType.NPCS,
			id,
		)
	)
	if all_results.size() <= 1:
		for map_data in spawn_maps:
			var map_id = map_data.get("id", map_data.id)
			(
				Gamedata
				. mods
				. remove_reference(
					DMod.ContentType.MAPS,
					map_id,
					DMod.ContentType.NPCS,
					id,
				)
			)
	parent.save_npcs_to_disk()
