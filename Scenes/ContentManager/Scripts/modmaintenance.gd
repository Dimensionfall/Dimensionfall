extends Control

# This script is meant to be used with the mod maintenance interface
# This script allows the user to select one of the scripts to perform a variety of functions
# When more functions need to be added, create a new scene and instantiate as a child instance
# under the vbox container and add it to the code below to update it's visibility.


@export var scriptOptionButton: OptionButton
@export var exportmapdata: Control
@export var selectmods: OptionButton
var selected_mod: String = "Dimensionfall":
	set(value):
		selected_mod = value
		exportmapdata.selected_mod = value


func _ready():
	# Populate the selectmods OptionButton
	populate_select_mods()

func _on_back_button_button_up():
	get_tree().change_scene_to_file("res://Scenes/ContentManager/modmanager.tscn")


# Update the visibility of script controls based on the selected index
# When adding new scripts, add them here in a new index
func _on_script_option_button_item_selected(index):
	hide_scripts()
	if index == 0:
		exportmapdata.visible = true


# Hide all script controls. When a new script is added, you must also add it here to be hidden
func hide_scripts():
	exportmapdata.visible = false


# Populate available mods in the OptionButton
func populate_select_mods() -> void:
	selectmods.clear()
	for mod_id in Gamedata.mods.get_all_mod_ids():
		selectmods.add_item(mod_id)
