extends Control

# This scene is intended to be used inside the item editor.
# It is supposed to edit exactly one type of ammo.

# Form elements.
@export var damage_number_box: SpinBox = null

var ditem: DItem = null:
	set(value):
		if not value:
			return
		ditem = value
		load_properties()


func save_properties() -> void:
	ditem.ammo.damage = int(damage_number_box.value)


func load_properties() -> void:
	if not ditem.ammo:
		print_debug("ditem.ammo is null, skipping property loading.")
		return
	damage_number_box.value = ditem.ammo.damage
