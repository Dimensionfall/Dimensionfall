extends GutTest

var item_manager: ItemManager

func before_all():
	var custom_mods: Array[DMod] = [Gamedata.mods.by_id('Core'), Gamedata.mods.by_id('Test')]
	Runtimedata.reconstruct(custom_mods)
	await get_tree().process_frame

func before_each():
	item_manager = preload('res://Scripts/item_manager.gd').new()
	add_child(item_manager)
	await get_tree().process_frame
	item_manager.playerInventory = item_manager.initialize_inventory()

func after_each():
	if item_manager:
		item_manager.queue_free()

func _create_control() -> CtrlInventoryStackedCustom:
	var scene := preload('res://Scenes/UI/CtrlInventoryStackedCustom.tscn')
	var control: CtrlInventoryStackedCustom = scene.instantiate()
	control.my_inventory = item_manager.playerInventory
	add_child(control)
	await get_tree().process_frame
	return control

func test_drop_option_always_present():
	var control = await _create_control()
	var item = item_manager.playerInventory.create_and_add_item('generic_test_item')
	control._build_context_menu([item])
	var texts: Array = []
	for i in range(control.context_menu.get_item_count()):
		texts.append(control.context_menu.get_item_text(i))
	assert_true(texts.has('Drop'), 'Drop option should always appear')

func test_inapplicable_actions_omitted():
	var control = await _create_control()
	var item = item_manager.playerInventory.create_and_add_item('generic_test_item')
	control._build_context_menu([item])
	var texts: Array = []
	for i in range(control.context_menu.get_item_count()):
		texts.append(control.context_menu.get_item_text(i))
	assert_false(texts.has('Reload'), 'Reload should not appear for generic item')
	assert_true(texts.has('Equip (left)'), 'Equip should appear for generic item')

func test_applicable_actions_present():
	var control = await _create_control()
	var item = item_manager.playerInventory.create_and_add_item('generic_test_pistol')
	control._build_context_menu([item])
	var texts: Array = []
	for i in range(control.context_menu.get_item_count()):
		texts.append(control.context_menu.get_item_text(i))
	assert_true(texts.has('Equip (left)'), 'Equip left should appear for pistol')
	assert_true(texts.has('Reload'), 'Reload should appear for pistol')
