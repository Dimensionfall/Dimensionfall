extends Control
class_name CharacterWindow

# These are references to the containers in the UI where stats and skills are displayed
@export var stats_container: VBoxContainer
@export var skills_container: GridContainer
var player_instance: CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	Helper.signal_broker.player_stat_changed.connect(_on_player_stat_changed)
	Helper.signal_broker.player_skill_changed.connect(_on_player_skill_changed)
	player_instance = get_tree().get_first_node_in_group("Players")
	_on_player_stat_changed(player_instance)
	_on_player_skill_changed(player_instance)
	visibility_changed.connect(_on_visibility_changed)


# Utility function to clear all children in a container
func clear_container(container: Control):
	for child in container.get_children():
		child.queue_free()


# Handles the update of the stats display when player stats change
func _on_player_stat_changed(player_node: CharacterBody3D):
	if not visible:
		return
	clear_container(stats_container)  # Clear existing content
	var playerstats = player_node.stats
	for stat_id in playerstats:
		var stat_data: RStat = Runtimedata.stats.by_id(stat_id)
		if stat_data:
			var stat_entry = create_stat_entry(stat_data, playerstats[stat_id])
			stats_container.add_child(stat_entry)


# Handles the update of the skills display when player skills change
func _on_player_skill_changed(player_node: CharacterBody3D):
	if not visible:
		return
	clear_container(skills_container)  # Clear existing content
	for skill_id in player_node.skills:
		var skill_data: RSkill = Runtimedata.skills.by_id(skill_id)
		if skill_data:
			var skill_value = player_node.skills[skill_id]
			var skill_entry = create_skill_entry(skill_data, skill_value)
			skills_container.add_child(skill_entry)


# Utility function to create an HBoxContainer for a stat or skill entry
func create_skill_entry(rskill: RSkill, value: Variant) -> HBoxContainer:
	var hbox = HBoxContainer.new()
	var icon = TextureRect.new()
	icon.texture = rskill.sprite
	hbox.add_child(icon)

	var label = Label.new()
	# For skills, display level and XP with a maximum of 2 decimal places
	var xp_value = str(round(value["xp"] * 100) / 100.0)  # Round XP to 2 decimal places
	label.text = rskill.name + ": Level " + str(value["level"]) + ", XP: " + xp_value
	label.tooltip_text = rskill.description
	hbox.add_child(label)

	return hbox


# Utility function to create an HBoxContainer for a stat or skill entry
func create_stat_entry(dstat: RStat, value: Variant) -> HBoxContainer:
	var hbox = HBoxContainer.new()
	var icon = TextureRect.new()
	icon.texture = dstat.sprite
	hbox.add_child(icon)

	var label = Label.new()
	# For stats, display the value directly
	label.text = dstat.name + ": " + str(value)
	label.tooltip_text = dstat.description
	hbox.add_child(label)

	return hbox


# New function to refresh stats and skills when the window becomes visible
func _on_visibility_changed():
	if visible:
		_on_player_stat_changed(player_instance)
		_on_player_skill_changed(player_instance)


# Closes the UI when the close button is pressed.
func _on_close_menu_button_button_up() -> void:
	self.hide()
