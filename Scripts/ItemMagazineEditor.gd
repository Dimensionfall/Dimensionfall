extends Control

# This scene is intended to be used inside the item editor.
# It is supposed to edit exactly one magazine.

# Form elements.
@export var used_ammo_text_edit: TextEdit = null
@export var max_ammo_number_box: SpinBox = null
@export var current_ammo_number_box: SpinBox = null

var ditem: DItem = null:
	set(value):
		if not value:
			return
		ditem = value
		load_properties()


func save_properties() -> void:
	ditem.magazine.used_ammo = used_ammo_text_edit.text
	ditem.magazine.max_ammo = int(max_ammo_number_box.value)
	ditem.magazine.current_ammo = int(current_ammo_number_box.value)


func load_properties() -> void:
	if not ditem.magazine:
		print_debug("ditem.magazine is null, skipping property loading.")
		return
	used_ammo_text_edit.text = ditem.magazine.used_ammo
	max_ammo_number_box.value = ditem.magazine.max_ammo
	current_ammo_number_box.value = ditem.magazine.current_ammo
