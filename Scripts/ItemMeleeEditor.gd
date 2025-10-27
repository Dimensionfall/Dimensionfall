extends Control

# This scene is intended to be used inside the item editor.
# It is supposed to edit exactly one type of melee weapon.

# Form elements.
@export var damage_spin_box: SpinBox = null
@export var reach_spin_box: SpinBox = null
@export var used_skill_text_edit: HBoxContainer = null
@export var skill_xp_spin_box: SpinBox = null
@export var damage_stat_text_edit: HBoxContainer = null
@export var accuracy_stat_text_edit: HBoxContainer = null

var ditem: DItem = null:
	set(value):
		if not value:
			return
		ditem = value
		load_properties()


func _ready():
	set_drop_functions()
	damage_stat_text_edit.content_types = [DMod.ContentType.STATS] as Array[DMod.ContentType]
	accuracy_stat_text_edit.content_types = [DMod.ContentType.STATS] as Array[DMod.ContentType]


# Load the properties from the ditem.melee and update the UI elements
func load_properties() -> void:
	if not ditem.melee:
		print_debug("ditem.melee is null, skipping property loading.")
		return
	if ditem.melee.damage:
		damage_spin_box.value = ditem.melee.damage
	if ditem.melee.reach:
		reach_spin_box.value = ditem.melee.reach

		if ditem.melee.used_skill.has("skill_id"):
			used_skill_text_edit.set_text(ditem.melee.used_skill["skill_id"])
		if ditem.melee.used_skill.has("xp"):
			skill_xp_spin_box.value = ditem.melee.used_skill["xp"]
	if ditem.melee.damage_stat != "":
		damage_stat_text_edit.set_text(ditem.melee.damage_stat)
	if ditem.melee.accuracy_stat != "":
		accuracy_stat_text_edit.set_text(ditem.melee.accuracy_stat)


# Save the properties from the UI elements back to ditem.melee
func save_properties() -> void:
	ditem.melee.damage = int(damage_spin_box.value)
	ditem.melee.reach = int(reach_spin_box.value)
	ditem.melee.damage_stat = damage_stat_text_edit.get_text()
	ditem.melee.accuracy_stat = accuracy_stat_text_edit.get_text()

	if used_skill_text_edit.get_text() != "":
		ditem.melee.used_skill = {
			"skill_id": used_skill_text_edit.get_text(), "xp": skill_xp_spin_box.value
		}
	else:
		ditem.melee.used_skill.clear()


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


# Set the drop functions on the required skill and skill progression controls.
# This enables them to receive drop data.
func set_drop_functions():
	used_skill_text_edit.drop_function = skill_drop.bind(used_skill_text_edit)
	used_skill_text_edit.can_drop_function = can_skill_drop
