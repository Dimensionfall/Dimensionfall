extends GutTest

var melee_editor_scene: PackedScene = preload(
	"res://Scenes/ContentManager/Custom_Editors/ItemEditor/ItemMeleeEditor.tscn"
)
var editor_instance: Control = null
var my_ditem: DItem = null


func before_all():
	var custom_mods: Array[DMod] = [Gamedata.mods.by_id("Core"), Gamedata.mods.by_id("Test")]
	Runtimedata.reconstruct(custom_mods)
	await get_tree().process_frame


func before_each():
	my_ditem = DItem.new(
		{
			"id": "test_melee_item",
			"Melee":
			{
				"damage": 5,
				"reach": 1,
				"used_skill": {"skill_id": "bashing", "xp": 1.0},
				"damage_stat": "strength",
				"accuracy_stat": "dexterity"
			}
		},
		null
	)
	editor_instance = melee_editor_scene.instantiate()
	get_tree().root.add_child(editor_instance)
	await get_tree().process_frame
	editor_instance.ditem = my_ditem


func after_each():
	if editor_instance:
		editor_instance.queue_free()


func after_all():
	Runtimedata.reset()


func test_editor_loads_melee_data():
	assert_eq(editor_instance.damage_spin_box.value, 5)
	assert_eq(editor_instance.reach_spin_box.value, 1)
	assert_eq(editor_instance.used_skill_text_edit.get_text(), "bashing")
	assert_eq(editor_instance.skill_xp_spin_box.value, 1.0)
	assert_eq(editor_instance.damage_stat_text_edit.get_text(), "strength")
	assert_eq(editor_instance.accuracy_stat_text_edit.get_text(), "dexterity")


func test_drop_damage_stat_and_save():
	var dropdata: Dictionary = {
		"id": "dexterity",
		"text": "dexterity",
		"mod_id": "Test",
		"contentType": DMod.ContentType.STATS
	}
	editor_instance.damage_stat_text_edit._drop_data(Vector2.ZERO, dropdata)
	assert_eq(editor_instance.damage_stat_text_edit.get_text(), "dexterity")
	editor_instance.save_properties()
	assert_eq(my_ditem.melee.damage_stat, "dexterity")


func test_drop_accuracy_stat_and_save():
	var dropdata: Dictionary = {
		"id": "strength",
		"text": "strength",
		"mod_id": "Test",
		"contentType": DMod.ContentType.STATS
	}
	editor_instance.accuracy_stat_text_edit._drop_data(Vector2.ZERO, dropdata)
	assert_eq(editor_instance.accuracy_stat_text_edit.get_text(), "strength")
	editor_instance.save_properties()
	assert_eq(my_ditem.melee.accuracy_stat, "strength")
