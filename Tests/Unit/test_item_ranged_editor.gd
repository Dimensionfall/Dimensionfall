extends GutTest

var ranged_editor_scene: PackedScene = preload(
	"res://Scenes/ContentManager/Custom_Editors/ItemEditor/ItemRangedEditor.tscn"
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
			"id": "test_ranged_item",
			"Ranged":
			{
				"firing_speed": 0.5,
				"range": 500,
				"recoil": 5,
				"reload_speed": 1.0,
				"spread": 2,
				"sway": 1,
				"used_ammo": "9mm",
				"used_magazine": ""
			}
		},
		null
	)
	editor_instance = ranged_editor_scene.instantiate()
	get_tree().root.add_child(editor_instance)
	await get_tree().process_frame
	editor_instance.ditem = my_ditem


func after_each():
	if editor_instance:
		editor_instance.queue_free()


func after_all():
	Runtimedata.reset()


func test_valid_magazine_drop() -> void:
	var data := {
		"id": "generic_test_pistol_magazine",
		"text": "generic_test_pistol_magazine",
		"mod_id": "Test",
		"contentType": DMod.ContentType.ITEMS
	}
	editor_instance._magazine_drop(Vector2.ZERO, data)
	var found := false
	for child in editor_instance.used_magazine_grid_container.get_children():
		if child is Label and child.text == "generic_test_pistol_magazine":
			found = true
	assert_true(found)


func test_invalid_magazine_drop() -> void:
	var data := {
		"id": "generic_test_item",
		"text": "generic_test_item",
		"mod_id": "Test",
		"contentType": DMod.ContentType.ITEMS
	}
	editor_instance._magazine_drop(Vector2.ZERO, data)
	var found := false
	for child in editor_instance.used_magazine_grid_container.get_children():
		if child is Label and child.text == "generic_test_item":
			found = true
	assert_false(found)


func test_save_and_load_preserves_magazines() -> void:
	var data := {
		"id": "generic_test_pistol_magazine",
		"text": "generic_test_pistol_magazine",
		"mod_id": "Test",
		"contentType": DMod.ContentType.ITEMS
	}
	editor_instance._magazine_drop(Vector2.ZERO, data)
	editor_instance.save_properties()
	assert_eq(my_ditem.ranged.used_magazine, "generic_test_pistol_magazine")
	Helper.free_all_children(editor_instance.used_magazine_grid_container)
	editor_instance.load_properties()
	var found := false
	for child in editor_instance.used_magazine_grid_container.get_children():
		if child is Label and child.text == "generic_test_pistol_magazine":
			found = true
	assert_true(found)
