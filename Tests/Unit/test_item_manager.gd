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


func after_all():
	Runtimedata.reset()


func _create_weapon() -> InventoryItem:
	return item_manager.playerInventory.create_and_add_item("generic_test_pistol")


func _create_magazine(ammo: int) -> InventoryItem:
	var mag: InventoryItem = item_manager.playerInventory.create_and_add_item(
		"generic_test_pistol_magazine"
	)
	var props = mag.get_property("Magazine")
	props["current_ammo"] = ammo
	mag.set_property("Magazine", props)
	return mag


func _create_ammo(amount: int) -> InventoryItem:
	var ammo: InventoryItem = item_manager.playerInventory.create_and_add_item("bullet_9mm")
	InventoryStacked.set_item_stack_size(ammo, amount)
	return ammo


func test_find_compatible_magazine() -> void:
	var gun = _create_weapon()
	var _low = _create_magazine(5)
	var high = _create_magazine(15)
	var compatible_magazine: InventoryItem = item_manager.find_compatible_magazine(gun)
	assert_not_null(compatible_magazine, "Expected find_compatible_magazine to return a magazine")
	assert_eq(compatible_magazine, high, "Should pick mag with most ammo")


func test_reload_weapon_no_magazine() -> void:
	var gun = _create_weapon()
	assert_false(item_manager.reload_weapon(gun), "Reload should fail without magazine")


func test_start_reload_inserts_magazine() -> void:
	var gun = _create_weapon()
	var mag = _create_magazine(10)
	item_manager.start_reload(gun, 0.01, mag)
	await wait_frames(5)
	assert_eq(gun.get_property("current_magazine"), mag, "Magazine should be inserted")
	assert_false(
		item_manager.playerInventory.has_item(mag), "Magazine should be removed from inventory"
	)
	assert_false(gun.get_property("is_reloading"), "Reload flag should reset")
