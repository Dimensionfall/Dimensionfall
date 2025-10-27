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


func _create_magazine(ammo: int) -> InventoryItem:
	var mag: InventoryItem = item_manager.playerInventory.create_and_add_item(
		"generic_test_pistol_magazine"
	)
	var props = mag.get_property("Magazine")
	props["current_ammo"] = ammo
	mag.set_property("Magazine", props)
	return mag


func _create_ammo(inv: InventoryStacked, amount: int) -> InventoryItem:
	var ammo: InventoryItem = inv.create_and_add_item("bullet_9mm")
	InventoryStacked.set_item_stack_size(ammo, amount)
	return ammo


func _setup_proximity_inventory() -> InventoryStacked:
	var prox = item_manager.initialize_inventory()
	item_manager.proximityInventories["test"] = prox
	item_manager.connect_inventory_signals(prox)
	item_manager.update_accessible_items_list()
	return prox


func test_no_reload_when_inventory_full() -> void:
	var mag = _create_magazine(0)
	item_manager.playerInventory.capacity = 0
	item_manager.player_max_inventory_volume = 0
	var prox = _setup_proximity_inventory()
	_create_ammo(prox, 5)
	item_manager.update_accessible_items_list()
	item_manager.reload_magazine(mag)
	var props = mag.get_property("Magazine")
	assert_eq(int(props["current_ammo"]), 0, "Magazine should not reload if inventory full")
