extends Control

@export var select_mods: OptionButton = null
@export var contentList: PackedScene = null
@export var mapEditor: PackedScene = null
@export var tacticalmapEditor: PackedScene = null
@export var terrainTileEditor: PackedScene = null
@export var furnitureEditor: PackedScene = null
@export var itemEditor: PackedScene = null
@export var mobEditor: PackedScene = null
@export var npcEditor: PackedScene = null
@export var itemgroupEditor: PackedScene = null
@export var wearableslotEditor: PackedScene = null
@export var statsEditor: PackedScene = null
@export var skillsEditor: PackedScene = null
@export var questsEditor: PackedScene = null
@export var playerattributesEditor: PackedScene = null
@export var overmapareaEditor: PackedScene = null
@export var mobgroupsEditor: PackedScene = null
@export var mobfactionsEditor: PackedScene = null
@export var attacksEditor: PackedScene = null
@export var content: VBoxContainer = null
@export var tabContainer: TabContainer = null
@export var type_selector_menu_button: MenuButton = null
@onready var editor_configs := {
	DMod.ContentType.MAPS: {"property": "currentMap", "scene": mapEditor},
	DMod.ContentType.TACTICALMAPS: {"property": "currentMap", "scene": tacticalmapEditor},
	DMod.ContentType.FURNITURES: {"property": "dfurniture", "scene": furnitureEditor},
	DMod.ContentType.ITEMGROUPS: {"property": "ditemgroup", "scene": itemgroupEditor},
	DMod.ContentType.ITEMS: {"property": "ditem", "scene": itemEditor},
	DMod.ContentType.TILES: {"property": "dtile", "scene": terrainTileEditor},
	DMod.ContentType.MOBS: {"property": "dmob", "scene": mobEditor},
	DMod.ContentType.PLAYERATTRIBUTES: {"property": "dplayerattribute", "scene": playerattributesEditor},
	DMod.ContentType.WEARABLESLOTS: {"property": "dwearableslot", "scene": wearableslotEditor},
	DMod.ContentType.STATS: {"property": "dstat", "scene": statsEditor},
	DMod.ContentType.SKILLS: {"property": "dskill", "scene": skillsEditor},
	DMod.ContentType.QUESTS: {"property": "dquest", "scene": questsEditor},
	DMod.ContentType.OVERMAPAREAS: {"property": "dovermaparea", "scene": overmapareaEditor},
	DMod.ContentType.MOBGROUPS: {"property": "dmobgroup", "scene": mobgroupsEditor},
	DMod.ContentType.MOBFACTIONS: {"property": "dmobfaction", "scene": mobfactionsEditor},
	DMod.ContentType.ATTACKS: {"property": "dattack", "scene": attacksEditor},
	DMod.ContentType.NPCS: {"property": "dnpc", "scene": npcEditor}
}
var selectedMod: String = "Core"

# This function will load the contents of the data into the contentListInstance
func _ready():
	#Pauses main menu music as soon as the scene is loaded
	Music.main_menu_music_pause()
	# Load the saved selected mod or default to "Core"
	selectedMod = load_selected_mod()

	# Populate the select_mods OptionButton
	populate_select_mods()

	# Use the refactored function to select the mod
	select_mod_from_saved_or_default(selectedMod)

	# Refresh lists with the loaded or default mod
	refresh_lists()


func select_mod_from_saved_or_default(selected_mod: String) -> void:
	# Find the index of the saved mod in the OptionButton
	var mod_index = -1
	for i in range(select_mods.get_item_count()):
		if select_mods.get_item_text(i) == selected_mod:
			mod_index = i
			break

	# If the mod is found, select it; otherwise, default to the first mod
	if mod_index >= 0:
		select_mods.select(mod_index)
	else:
		selectedMod = "Core"  # Fallback to "Core" if the mod doesn't exist
		select_mods.select(0)


func refresh_lists() -> void:
	# Clear existing content in the VBoxContainer
	for child in content.get_children():
		content.remove_child(child)
		child.queue_free()  # Ensure the nodes are properly removed and freed

	# Reload content lists for the currently selected mod
	load_content_list(DMod.ContentType.MAPS, "Maps")
	load_content_list(DMod.ContentType.TACTICALMAPS, "Tactical Maps")
	load_content_list(DMod.ContentType.ITEMS, "Items")
	load_content_list(DMod.ContentType.TILES, "Terrain Tiles")
	load_content_list(DMod.ContentType.MOBS, "Mobs")
	load_content_list(DMod.ContentType.FURNITURES, "Furniture")
	load_content_list(DMod.ContentType.ITEMGROUPS, "Item Groups")
	load_content_list(DMod.ContentType.PLAYERATTRIBUTES, "Player Attributes")
	load_content_list(DMod.ContentType.WEARABLESLOTS, "Wearable Slots")
	load_content_list(DMod.ContentType.STATS, "Stats")
	load_content_list(DMod.ContentType.SKILLS, "Skills")
	load_content_list(DMod.ContentType.QUESTS, "Quests")
	load_content_list(DMod.ContentType.OVERMAPAREAS, "Overmap areas")
	load_content_list(DMod.ContentType.MOBGROUPS, "Mob groups")
	load_content_list(DMod.ContentType.MOBFACTIONS, "Mob factions")
	load_content_list(DMod.ContentType.ATTACKS, "Attacks")
	load_content_list(DMod.ContentType.NPCS, "NPCs")
	
	# Repopulate the type selector menu
	populate_type_selector_menu_button()


# Clears the select_mods OptionButton and populates it with mod IDs from Gamedata.mods
func populate_select_mods() -> void:
	select_mods.clear()  # Remove all existing options from the OptionButton
	var mod_ids: Array = Gamedata.mods.get_all_mod_ids()
	
	# Iterate through Gamedata.mods and add each mod ID as an option
	for mod_id in mod_ids:
		select_mods.add_item(mod_id)


func load_content_list(type: DMod.ContentType, strHeader: String):
	# Instantiate a content list
	var contentListInstance: Control = contentList.instantiate()

	# Set the source properties, dynamically using the selectedMod ID
	contentListInstance.header = strHeader
	contentListInstance.mod_id = selectedMod  # Use the current mod ID
	contentListInstance.contentType = type
	contentListInstance.item_activated.connect(_on_content_item_activated)

	# Add it as a child to the content VBoxContainer
	content.add_child(contentListInstance)


func _on_back_button_button_up():
	Music.main_menu_music_resume()
	get_tree().change_scene_to_file("res://Scenes/ContentManager/contentmanager.tscn")


# The user has double-clicked or pressed enter on one of the items in the content lists
# Depending on whether the source is a JSON file, we are going to load the relevant content
func _on_content_item_activated(type: DMod.ContentType, itemID: String, list: Control):
	if itemID == "":
		print_debug("Tried to load the selected content item, but either \
		data (Array) or itemID ("+itemID+") is empty")
		return

	instantiate_editor(type, itemID, list)


# This will add an editor to the content editor tab view. 
# The editor that should be instantiated is passed through in the newEditor parameter
# It is important that the editor has the property contentSource or contentData so it can be set
# If a tab for the given itemID already exists, switch to that tab.
# Otherwise, instantiate a new editor.
func instantiate_editor(type: DMod.ContentType, itemID: String, list: Control):
	# Check if a tab for the itemID already exists
	for i in range(tabContainer.get_child_count()):
		var child = tabContainer.get_child(i)
		if child.name == itemID:
			# Tab for itemID exists, switch to this tab
			tabContainer.current_tab = i
			return

	# If no existing tab is found, instantiate a new editor using the mapping
	var info: Dictionary = editor_configs.get(type, null)
	if info == null:
		print("Unknown content type:", type)
		return

	var newContentEditor: Control = info.scene.instantiate()
	newContentEditor.name = itemID
	tabContainer.add_child(newContentEditor)
	tabContainer.current_tab = tabContainer.get_child_count() - 1

	var currentmod: DMod = Gamedata.mods.by_id(selectedMod)
	var data_instance: RefCounted = currentmod.get_data_of_type(type).by_id(itemID)
	newContentEditor.set(info.property, data_instance)

	if newContentEditor.has_signal("data_changed") and not newContentEditor.data_changed.is_connected(list.load_data):
		newContentEditor.data_changed.connect(list.load_data)


# Function to populate the type_selector_menu_button with content list headers and load their state
func populate_type_selector_menu_button():
	var popup_menu = type_selector_menu_button.get_popup()
	popup_menu.clear()  # Clear any existing items
	
	var config = ConfigFile.new()
	var path = "user://settings.cfg"
	config.load(path)  # Load existing settings if available

	# Define a list of headers to add to the menu button
	var headers = [
		"Maps", "Tactical Maps", "Items", "Terrain Tiles", "Mobs", 
		"Furniture", "Item Groups", "Player Attributes", "Wearable Slots", 
		"Stats", "Skills", "Quests", "Overmap areas", "Mob groups", "Mob factions", "Attacks", "NPCs"
	]
	
	for i in headers.size():
		var item_text = headers[i]
		popup_menu.add_check_item(item_text, i)  # Add a checkable item

		# Load saved state or default to checked if not found
		var is_checked = config.get_value("type_selector", item_text, true)
		popup_menu.set_item_checked(i, is_checked)

		# Show or hide the content list based on the state
		if is_checked:
			show_content_list(item_text)
		else:
			hide_content_list(item_text)

	# Connect item selection signal to save state when changed
	if not popup_menu.id_pressed.is_connected(_on_type_selected):
		popup_menu.id_pressed.connect(_on_type_selected)


# Function to handle item selection from the popup menu and save the state
func _on_type_selected(id):
	var popup_menu = type_selector_menu_button.get_popup()
	var item_text = popup_menu.get_item_text(id)
	
	# Toggle the checked state of the item
	var is_checked = popup_menu.is_item_checked(id)
	popup_menu.set_item_checked(id, not is_checked)

	# Show or hide the content list based on the checked state
	if not is_checked:
		show_content_list(item_text)
	else:
		hide_content_list(item_text)

	# Save the new state to the configuration file
	save_item_state(item_text, not is_checked)

# Function to show a content list with the given header text
func show_content_list(header_text: String):
	for child in content.get_children():
		if child is Control and child.header == header_text:
			child.visible = true
			break

# Function to hide a content list with the given header text
func hide_content_list(header_text: String):
	for child in content.get_children():
		if child is Control and child.header == header_text:
			child.visible = false
			break

# Function to save the state of an item to the configuration file
func save_item_state(item_text: String, is_checked: bool):
	var config = ConfigFile.new()
	var path = "user://settings.cfg"
	
	# Load existing settings to not overwrite them
	var err = config.load(path)
	if err != OK and err != ERR_FILE_NOT_FOUND:
		print("Failed to load settings:", err)
		return

	config.set_value("type_selector", item_text, is_checked)
	config.save(path)


func _on_select_mods_item_selected(index: int) -> void:
	# Read the mod ID from the select_mods OptionButton
	selectedMod = select_mods.get_item_text(index)

	# Save the selected mod
	save_selected_mod(selectedMod)

	# Refresh the lists with the new mod ID
	refresh_lists()


### PERSISTENCE ###

# Saves the currently selected mod to a configuration file.
func save_selected_mod(mod_id: String) -> void:
	var config = ConfigFile.new()
	var path = "user://settings.cfg"
	if config.load(path) != OK:
		print_debug("Failed to load settings for saving selected mod.")
	config.set_value("mapeditor", "selected_mod", mod_id)
	if config.save(path) != OK:
		print_debug("Failed to save settings.")


# Loads the selected mod from a configuration file or defaults to "Core".
func load_selected_mod() -> String:
	var config = ConfigFile.new()
	var path = "user://settings.cfg"
	if config.load(path) != OK:
		print_debug("Failed to load settings, defaulting to 'Core'.")
	return config.get_value("mapeditor", "selected_mod", "Core")
