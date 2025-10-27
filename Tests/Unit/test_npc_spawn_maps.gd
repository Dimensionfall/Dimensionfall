extends GutTest

var orig_content: String
var path := "./Mods/Test/Npcs/Npcs.json"


func before_all():
	if FileAccess.file_exists(path):
		orig_content = FileAccess.get_file_as_string(path)
	else:
		orig_content = "[]"
	var custom_mods: Array[DMod] = [Gamedata.mods.by_id("Core"), Gamedata.mods.by_id("Test")]
	Runtimedata.reconstruct(custom_mods)
	await get_tree().process_frame


func after_all():
	Helper.json_helper.write_json_file(path, orig_content)
	Runtimedata.reset()


func test_spawn_maps_persist() -> void:
	var dnpcs := DNpcs.new("Test")
	var npc := DNpc.new(
		{
			"id": "spawn_test",
			"name": "Spawn Test",
			"spawn_maps": [{"id": "Generichouse", "weight": 50}]
		},
		dnpcs
	)
	dnpcs.append_new(npc)
	var dnpcs_reload := DNpcs.new("Test")
	assert_true(dnpcs_reload.has_id("spawn_test"))
	var loaded := dnpcs_reload.by_id("spawn_test")
	assert_eq(loaded.spawn_maps.size(), 1)
	assert_eq(loaded.spawn_maps[0].id, "Generichouse")
	dnpcs_reload.delete_by_id("spawn_test")
