class_name TestDropEntityTextEdit
extends GutTest

var drop_scene: PackedScene = preload("res://Scenes/ContentManager/Custom_Widgets/DropEntityTextEdit.tscn")
var drop_widget: HBoxContainer

func before_all():
	var custom_mods: Array[DMod] = [Gamedata.mods.by_id("Core"), Gamedata.mods.by_id("Test")]
	Runtimedata.reconstruct(custom_mods)
	await get_tree().process_frame

func before_each():
	drop_widget = drop_scene.instantiate()
	add_child(drop_widget)
	var mycontenttypes: Array[DMod.ContentType] = [DMod.ContentType.WEARABLESLOTS, DMod.ContentType.PLAYERATTRIBUTES]
	drop_widget.set_content_types(mycontenttypes)
	await get_tree().process_frame

func after_each():
	if drop_widget:
		drop_widget.queue_free()

func after_all():
	Runtimedata.reset()

func test_can_drop_valid_data() -> void:
	var data := {
		"id": "generic_test_wearable_slot",
		"text": "Test wearable slot",
		"mod_id": "Test",
		"contentType": DMod.ContentType.WEARABLESLOTS
	}
	assert_true(drop_widget._can_drop_data(Vector2.ZERO, data))

func test_can_drop_invalid_id() -> void:
	var data := {
		"id": "non_existing_slot",
		"text": "Bad slot",
		"mod_id": "Test",
		"contentType": DMod.ContentType.WEARABLESLOTS
	}
	assert_false(drop_widget._can_drop_data(Vector2.ZERO, data))

func test_can_drop_wrong_type() -> void:
	var data := {
		"id": "generic_test_wearable_slot",
		"text": "Test wearable slot",
		"mod_id": "Test",
		"contentType": DMod.ContentType.MAPS
	}
	assert_false(drop_widget._can_drop_data(Vector2.ZERO, data))

func test_drop_data_updates_state() -> void:
	var data := {
		"id": "generic_test_wearable_slot",
		"text": "Test wearable slot",
		"mod_id": "Test",
		"contentType": DMod.ContentType.WEARABLESLOTS
	}
	assert_true(drop_widget.dropped_data.is_empty())
	drop_widget._drop_data(Vector2.ZERO, data)
	assert_eq(drop_widget.dropped_data, data)
	assert_eq(drop_widget.get_text(), "generic_test_wearable_slot")

func test_drop_data_rejects_invalid() -> void:
	var data := {
		"id": "non_existing_slot",
		"text": "Bad slot",
		"mod_id": "Test",
		"contentType": DMod.ContentType.WEARABLESLOTS
	}
	drop_widget._drop_data(Vector2.ZERO, data)
	assert_true(drop_widget.dropped_data.is_empty())
	assert_eq(drop_widget.get_text(), "")
