extends Control

@export var npcImageDisplay: TextureRect
@export var IDTextLabel: Label
@export var PathTextLabel: Label
@export var NameTextEdit: TextEdit
@export var DescriptionTextEdit: TextEdit
@export var healthSpinBox: SpinBox
@export var npcSelector: Popup
@export var spawnMapsGrid: GridContainer

signal data_changed

var olddata: DNpc
var dnpc: DNpc:
	set(value):
		dnpc = value
		load_npc_data()
		npcSelector.sprites_collection = dnpc.parent.sprites
		olddata = DNpc.new(dnpc.get_data().duplicate(true), dnpc.parent)


func load_npc_data() -> void:
	if dnpc.spriteid != "":
		npcImageDisplay.texture = dnpc.sprite
		PathTextLabel.text = dnpc.spriteid
	IDTextLabel.text = str(dnpc.id)
	NameTextEdit.text = dnpc.name
	DescriptionTextEdit.text = dnpc.description
	healthSpinBox.value = dnpc.health
	_load_spawn_maps_into_ui(dnpc.spawn_maps)


func _on_close_button_button_up() -> void:
	queue_free()


func _on_save_button_button_up() -> void:
	dnpc.spriteid = PathTextLabel.text
	dnpc.name = NameTextEdit.text
	dnpc.description = DescriptionTextEdit.text
	dnpc.sprite = npcImageDisplay.texture
	dnpc.health = int(healthSpinBox.value)
	dnpc.spawn_maps = _get_spawn_maps_from_ui()
	dnpc.changed(olddata)
	dnpc.save_to_disk()
	data_changed.emit()
	olddata = DNpc.new(dnpc.get_data().duplicate(true), dnpc.parent)


func _on_npc_image_display_gui_input(event) -> void:
	if event is InputEventMouseButton and event.pressed:
		npcSelector.show()


func _on_sprite_selector_sprite_selected_ok(clicked_sprite) -> void:
	var npcTexture: Resource = clicked_sprite.get_texture()
	npcImageDisplay.texture = npcTexture
	PathTextLabel.text = npcTexture.resource_path.get_file()


# -------------------- Spawn Maps Handling --------------------


func _ready() -> void:
	spawnMapsGrid.set_drag_forwarding(Callable(), _can_drop_map_data, _drop_map_data)


func _load_spawn_maps_into_ui(spawn_maps: Array) -> void:
	for child in spawnMapsGrid.get_children():
		child.queue_free()
	for map_data in spawn_maps:
		_add_spawn_map_entry(map_data)


func _get_spawn_maps_from_ui() -> Array:
	var result: Array = []
	var children = spawnMapsGrid.get_children()
	for i in range(0, children.size(), 4):
		var id_label = children[i + 1] as Label
		var weight_spinbox = children[i + 2] as SpinBox
		result.append({"id": id_label.text, "weight": int(weight_spinbox.value)})
	return result


func _can_drop_map_data(_newpos, data) -> bool:
	if not data or not data.has("id"):
		return false
	if not Gamedata.mods.get_content_by_id(DMod.ContentType.MAPS, data["id"]):
		return false
	for i in range(1, spawnMapsGrid.get_child_count(), 4):
		var lbl = spawnMapsGrid.get_child(i) as Label
		if lbl.text == data["id"]:
			return false
	return true


func _drop_map_data(newpos, data) -> void:
	if _can_drop_map_data(newpos, data):
		_add_spawn_map_entry({"id": data["id"], "weight": 100})


func _add_spawn_map_entry(map_data: Dictionary) -> void:
	var map = Gamedata.mods.get_content_by_id(DMod.ContentType.MAPS, map_data.id)
	var tex_rect := TextureRect.new()
	tex_rect.texture = map.sprite
	tex_rect.custom_minimum_size = Vector2(32, 32)
	tex_rect.stretch_mode = TextureRect.STRETCH_SCALE
	tex_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	spawnMapsGrid.add_child(tex_rect)

	var id_label := Label.new()
	id_label.text = map.id
	spawnMapsGrid.add_child(id_label)

	var weight_spin := SpinBox.new()
	weight_spin.min_value = 1
	weight_spin.max_value = 100
	weight_spin.value = map_data.get("weight", 100)
	spawnMapsGrid.add_child(weight_spin)

	var del_button := Button.new()
	del_button.text = "X"
	spawnMapsGrid.add_child(del_button)
	del_button.button_up.connect(
		func(): _remove_spawn_map_entry(tex_rect, id_label, weight_spin, del_button)
	)


func _remove_spawn_map_entry(t: TextureRect, l: Label, s: SpinBox, b: Button) -> void:
	spawnMapsGrid.remove_child(t)
	t.queue_free()
	spawnMapsGrid.remove_child(l)
	l.queue_free()
	spawnMapsGrid.remove_child(s)
	s.queue_free()
	spawnMapsGrid.remove_child(b)
	b.queue_free()
