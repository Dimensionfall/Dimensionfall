class_name RNpcs
extends RefCounted

var npcdict: Dictionary = {}

func _init(mod_list: Array[DMod]) -> void:
	for mod in mod_list:
		var dnpcs: DNpcs = mod.npcs
		for dnpc_id: String in dnpcs.get_all().keys():
			var dnpc: DNpc = dnpcs.by_id(dnpc_id)
			var rnpc: RNpc
			if not npcdict.has(dnpc_id):
				rnpc = add_new(dnpc_id)
			else:
				rnpc = npcdict[dnpc_id]
			rnpc.overwrite_from_dnpc(dnpc)

func get_all() -> Dictionary:
	return npcdict

func add_new(newid: String) -> RNpc:
	var rnpc: RNpc = RNpc.new(self, newid)
	npcdict[newid] = rnpc
	return rnpc

func delete_by_id(npcid: String) -> void:
	npcdict[npcid].delete()
	npcdict.erase(npcid)

func by_id(npcid: String) -> RNpc:
	return npcdict[npcid]

func has_id(npcid: String) -> bool:
	return npcdict.has(npcid)

func sprite_by_id(npcid: String) -> Texture:
	return npcdict[npcid].sprite
