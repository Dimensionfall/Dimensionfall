extends Control

# This scene is intended to be used inside the item editor.
# It is supposed to edit exactly one ranged weapon.

# Ranged form elements.
@export var used_ammo_text_edit: TextEdit = null
@export var used_magazine_grid_container: GridContainer = null  # Holds magazine entries in a grid.
@export var range_number_box: SpinBox = null
@export var spread_number_box: SpinBox = null
@export var sway_number_box: SpinBox = null
@export var recoil_number_box: SpinBox = null
@export var used_skill_text_edit: HBoxContainer = null
@export var skill_xp_spin_box: SpinBox = null
@export var reload_speed_number_box: SpinBox = null
@export var firing_speed_number_box: SpinBox = null
@export var accuracy_stat_text_edit: HBoxContainer = null

var ditem: DItem = null:
	set(value):
		if not value:
			return
		ditem = value
		load_properties()


func _ready():
	set_drop_functions()
	if used_magazine_grid_container:
		used_magazine_grid_container.set_drag_forwarding(
			Callable(), _can_magazine_drop, _magazine_drop
		)


func _add_magazine_entry(magazine_id: String) -> void:
	var item_sprite: Texture = (
		Gamedata.mods.get_content_by_id(DMod.ContentType.ITEMS, magazine_id).sprite
	)
	var icon = TextureRect.new()
	icon.texture = item_sprite
	icon.custom_minimum_size = Vector2(32, 32)

	var label = Label.new()
	label.text = magazine_id

	var delete_button = Button.new()
	delete_button.text = "X"
	delete_button.button_up.connect(
		_on_delete_magazine_button_pressed.bind([icon, label, delete_button])
	)

	used_magazine_grid_container.add_child(icon)
	used_magazine_grid_container.add_child(label)
	used_magazine_grid_container.add_child(delete_button)


# Returns the properties of the ranged tab in the item editor.
func save_properties() -> void:
	var selected_magazines: Array[String] = []
	var num_columns: int = used_magazine_grid_container.columns
	var children := used_magazine_grid_container.get_children()
	for i in range(0, children.size(), num_columns):
		var label := children[i + 1] as Label
		if label:
			selected_magazines.append(label.text)

	ditem.ranged.used_ammo = used_ammo_text_edit.text
	ditem.ranged.used_magazine = ",".join(selected_magazines)  # Join the selected magazines by commas
	ditem.ranged.firing_range = int(range_number_box.value)
	ditem.ranged.spread = int(spread_number_box.value)
	ditem.ranged.sway = int(sway_number_box.value)
	ditem.ranged.recoil = int(recoil_number_box.value)
	ditem.ranged.reload_speed = reload_speed_number_box.value
	ditem.ranged.firing_speed = firing_speed_number_box.value
	ditem.ranged.accuracy_stat = accuracy_stat_text_edit.get_text()

# Only include used_skill if used_skill_text_edit has a value.
	if used_skill_text_edit.get_text() != "":
		ditem.ranged.used_skill = {
			"skill_id": used_skill_text_edit.get_text(), "xp": skill_xp_spin_box.value
		}
	else:
		ditem.ranged.used_skill.clear()


func load_properties() -> void:
	if not ditem.ranged:
		print_debug("ditem.ranged is null, skipping property loading.")
		return
	if ditem.ranged.used_ammo != "":
		used_ammo_text_edit.text = ditem.ranged.used_ammo
		if used_magazine_grid_container:
			Helper.free_all_children(used_magazine_grid_container)
		if ditem.ranged.used_magazine != "":
			var used_magazines = ditem.ranged.used_magazine.split(",")
			for mag_id in used_magazines:
				_add_magazine_entry(mag_id)
	range_number_box.value = ditem.ranged.firing_range
	spread_number_box.value = ditem.ranged.spread
	sway_number_box.value = ditem.ranged.sway
	recoil_number_box.value = ditem.ranged.recoil
	reload_speed_number_box.value = ditem.ranged.reload_speed
	firing_speed_number_box.value = ditem.ranged.firing_speed
	accuracy_stat_text_edit.set_text(ditem.ranged.accuracy_stat)

	if ditem.ranged.used_skill.has("skill_id"):
		used_skill_text_edit.set_text(ditem.ranged.used_skill["skill_id"])
	if ditem.ranged.used_skill.has("xp"):
		skill_xp_spin_box.value = ditem.ranged.used_skill["xp"]


# Called when the user successfully drops data onto the skillTextEdit.
# Checks the `dropped_data` dictionary for the `id` property.
func skill_drop(dropped_data: Dictionary, texteditcontrol: HBoxContainer) -> void:
	# dropped_data is a Dictionary that includes an 'id'
	if dropped_data and "id" in dropped_data:
		var skill_id = dropped_data["id"]
		if not Gamedata.mods.by_id(dropped_data["mod_id"]).skills.has_id(skill_id):
			print_debug("No item data found for ID: " + skill_id)
			return
		texteditcontrol.set_text(skill_id)
	else:
		print_debug("Dropped data does not contain an 'id' key.")


func can_skill_drop(dropped_data: Dictionary):
	# Check if the data dictionary has the 'id' property
	if not dropped_data or not dropped_data.has("id"):
		return false

	# Fetch skill data by ID from the Gamedata to ensure it exists and is valid
	if not Gamedata.mods.by_id(dropped_data["mod_id"]).skills.has_id(dropped_data["id"]):
		return false

	# If all checks pass, return true
	return true


func stat_drop(dropped_data: Dictionary, texteditcontrol: HBoxContainer) -> void:
	if dropped_data and dropped_data.has("id"):
		var stat_id = dropped_data["id"]
		if not Gamedata.mods.by_id(dropped_data["mod_id"]).stats.has_id(stat_id):
			print_debug("No stat data found for ID: " + stat_id)
			return
		texteditcontrol.set_text(stat_id)
	else:
		print_debug("Dropped data does not contain an 'id' key.")


func can_stat_drop(dropped_data: Dictionary):
	if not dropped_data or not dropped_data.has("id"):
		return false
	return Gamedata.mods.by_id(dropped_data["mod_id"]).stats.has_id(dropped_data["id"])


# -------------------- Magazine Drag and Drop --------------------
func _can_magazine_drop(_newpos: Vector2, data: Dictionary) -> bool:
	if not data or not data.has("id") or not data.has("mod_id"):
		return false

	if not Gamedata.mods.by_id(data["mod_id"]).items.has_id(data["id"]):
		return false
	var ditem: DItem = Gamedata.mods.by_id(data["mod_id"]).items.by_id(data["id"])
	if ditem.magazine == null:
		return false

	for child in used_magazine_grid_container.get_children():
		if child is Label and child.text == data["id"]:
			return false
	return true


func _magazine_drop(_newpos: Vector2, data: Dictionary) -> void:
	if not _can_magazine_drop(_newpos, data):
		return
	_add_magazine_entry(data["id"])


func _on_delete_magazine_button_pressed(controls: Array) -> void:
	for c in controls:
		c.queue_free()


# Set the drop functions on the required skill and skill progression controls.
# This enables them to receive drop data.
func set_drop_functions():
	used_skill_text_edit.drop_function = skill_drop.bind(used_skill_text_edit)
	used_skill_text_edit.can_drop_function = can_skill_drop
	accuracy_stat_text_edit.drop_function = stat_drop.bind(accuracy_stat_text_edit)
	accuracy_stat_text_edit.can_drop_function = can_stat_drop
