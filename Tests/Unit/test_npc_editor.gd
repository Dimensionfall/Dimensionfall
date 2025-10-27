extends GutTest

var npc_editor_scene: PackedScene = preload(
	"res://Scenes/ContentManager/Custom_Editors/NpcEditor.tscn"
)
var editor_instance: Control = null
var my_dnpcs: DNpcs = null
var my_dnpc: DNpc = null


func before_all():
	var custom_mods: Array[DMod] = [Gamedata.mods.by_id("Core"), Gamedata.mods.by_id("Test")]
	Runtimedata.reconstruct(custom_mods)
	await get_tree().process_frame


func before_each():
	my_dnpcs = DNpcs.new("Test")
	my_dnpc = DNpc.new(
		{
			"id": "test_npc",
			"name": "Testy",
			"description": "A test NPC",
			"sprite": "",
			"health": 10
		},
		my_dnpcs
	)
	my_dnpcs.append_new(my_dnpc)
	editor_instance = npc_editor_scene.instantiate()
	get_tree().root.add_child(editor_instance)
	await get_tree().process_frame
	editor_instance.dnpc = my_dnpc


func after_each():
	if editor_instance:
		editor_instance.queue_free()


func after_all():
	Runtimedata.reset()


func test_editor_loads_npc_data() -> void:
	assert_eq(editor_instance.IDTextLabel.text, "test_npc")
	assert_eq(editor_instance.NameTextEdit.text, "Testy")
	assert_eq(editor_instance.DescriptionTextEdit.text, "A test NPC")
	assert_eq(editor_instance.healthSpinBox.value, 10)


func test_editor_saves_npc_data() -> void:
	editor_instance.NameTextEdit.text = "NewName"
	editor_instance.DescriptionTextEdit.text = "New Description"
	editor_instance.healthSpinBox.value = 50
	editor_instance._on_save_button_button_up()
	assert_eq(my_dnpc.name, "NewName")
	assert_eq(my_dnpc.description, "New Description")
	assert_eq(my_dnpc.health, 50)
	my_dnpcs.delete_by_id("test_npc")


func test_spawn_map_ui_loads_and_saves() -> void:
	my_dnpc.spawn_maps = [{"id": "basic_test_map", "weight": 50}]
	editor_instance.dnpc = my_dnpc
	await get_tree().process_frame

	assert_eq(editor_instance.spawnMapsGrid.get_child_count(), 4)
	var id_label := editor_instance.spawnMapsGrid.get_child(1) as Label
	var spin_box := editor_instance.spawnMapsGrid.get_child(2) as SpinBox
	assert_eq(id_label.text, "basic_test_map")
	assert_eq(spin_box.value, 50)

	spin_box.value = 20
	editor_instance._on_save_button_button_up()
	assert_eq(my_dnpc.spawn_maps[0].weight, 20)
	my_dnpcs.delete_by_id("test_npc")
