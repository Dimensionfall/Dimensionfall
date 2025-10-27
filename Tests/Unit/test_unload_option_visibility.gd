extends GutTest

var item_manager: ItemManager


func before_all():
	var custom_mods: Array[DMod] = [Gamedata.mods.by_id("Core"), Gamedata.mods.by_id("Test")]
	Runtimedata.reconstruct(custom_mods)
	await get_tree().process_frame


func before_each():
	item_manager = preload("res://Scripts/item_manager.gd").new()
	add_child(item_manager)
	await get_tree().process_frame
	item_manager.playerInventory = item_manager.initialize_inventory()


func after_each():
	if item_manager:
		item_manager.queue_free()


func _create_control() -> CtrlInventoryStackedCustom:
	var scene := preload("res://Scenes/UI/CtrlInventoryStackedCustom.tscn")
	var control: CtrlInventoryStackedCustom = scene.instantiate()
	control.my_inventory = item_manager.playerInventory
	add_child(control)
	await get_tree().process_frame
	return control


func _get_menu_texts(control: CtrlInventoryStackedCustom) -> Array:
	var texts: Array = []
	for i in range(control.context_menu.get_item_count()):
		texts.append(control.context_menu.get_item_text(i))
	return texts


func test_unload_hidden_without_magazine():
	var control = await _create_control()
	var gun = item_manager.playerInventory.create_and_add_item("generic_test_pistol")
	control._build_context_menu([gun])
	var texts = _get_menu_texts(control)
	assert_false(texts.has("Unload"), "Unload should be hidden when no magazine is inserted")


func test_unload_visible_with_magazine():
	var control = await _create_control()
	var gun = item_manager.playerInventory.create_and_add_item("generic_test_pistol")
	var mag = item_manager.playerInventory.create_and_add_item("generic_test_pistol_magazine")
	item_manager.insert_magazine(gun, mag)
	control._build_context_menu([gun])
	var texts = _get_menu_texts(control)
	var reload_index = texts.find("Reload")
	var unload_index = texts.find("Unload")
	assert_ne(unload_index, -1, "Unload should appear when magazine inserted")
	assert_gt(unload_index, reload_index, "Unload should come after Reload")
