extends GutTest

var editor_scene: PackedScene = preload(
	"res://Scenes/ContentManager/Custom_Editors/ItemgroupEditor.tscn"
)
var editor_instance: Control = null


func before_all():
	var custom_mods: Array[DMod] = [Gamedata.mods.by_id("Core"), Gamedata.mods.by_id("Test")]
	Runtimedata.reconstruct(custom_mods)
	await get_tree().process_frame


func before_each():
	editor_instance = editor_scene.instantiate()
	get_tree().root.add_child(editor_instance)
	await get_tree().process_frame
	editor_instance.add_header_row()


func after_each():
	if editor_instance:
		editor_instance.queue_free()


func after_all():
	Runtimedata.reset()


func test_duplicate_drop_is_ignored() -> void:
	var data := {
		"id": "generic_test_item",
		"text": "generic_test_item",
		"mod_id": "Test",
		"contentType": DMod.ContentType.ITEMS
	}
	editor_instance._drop_data(Vector2.ZERO, data)
	editor_instance._drop_data(Vector2.ZERO, data)
	var count := 0
	var num_children: int = editor_instance.itemListContainer.get_child_count()
	var num_columns: int = editor_instance.itemListContainer.columns
	for i in range(0, num_children, num_columns):
		var label: Label = editor_instance.itemListContainer.get_child(i + 1)
		if label.text == "generic_test_item":
			count += 1
	assert_eq(count, 1)
