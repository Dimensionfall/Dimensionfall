class_name DNpcs
extends RefCounted

var npc_path: String = "./Mods/Core/Npcs/"
var file_path: String = npc_path + "Npcs.json"
var npcdict: Dictionary = {}
var sprites: Dictionary = {}
var mod_id: String = "Core"


func _init(new_mod_id: String) -> void:
	mod_id = new_mod_id
	npc_path = "./Mods/" + mod_id + "/Npcs/"
	file_path = npc_path + "Npcs.json"
	load_sprites()
	load_npcs_from_disk()


func load_sprites() -> void:
	var png_files: Array = Helper.json_helper.file_names_in_dir(npc_path, ["png"])
	for png_file in png_files:
		sprites[png_file] = load(npc_path + png_file)


# Load all npc data from disk into memory
func load_npcs_from_disk() -> void:
		var npclist: Array = Helper.json_helper.load_json_array_file(file_path)
		for npc_data in npclist:
			var npc: DNpc = DNpc.new(npc_data, self)
			if npc.spriteid:
					npc.sprite = sprites[npc.spriteid]
			npcdict[npc.id] = npc


func get_all() -> Dictionary:
	return npcdict


func by_id(npcid: String) -> DNpc:
	return npcdict[npcid]


func has_id(npcid: String) -> bool:
	return npcdict.has(npcid)


func sprite_by_id(npcid: String) -> Texture:
	return npcdict[npcid].sprite


func sprite_by_file(spritefile: String) -> Texture:
	return sprites.get(spritefile, null)


# Save all NPC data to disk
func save_npcs_to_disk() -> void:
	var save_data: Array = []
	for npc in npcdict.values():
		save_data.append(npc.get_data())
	Helper.json_helper.write_json_file(file_path, JSON.stringify(save_data, "\t"))


# Add a new NPC with the given ID
func add_new(newid: String) -> void:
	append_new(DNpc.new({"id": newid}, self))


# Append an existing NPC to the dictionary and persist
func append_new(newnpc: DNpc) -> void:
	npcdict[newnpc.id] = newnpc
	save_npcs_to_disk()


# Delete an NPC by its ID and save changes
func delete_by_id(npcid: String) -> void:
	if npcdict.has(npcid):
		npcdict[npcid].delete()
		npcdict.erase(npcid)
		save_npcs_to_disk()
