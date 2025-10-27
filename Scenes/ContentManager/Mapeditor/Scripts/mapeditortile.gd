extends Control

const defaultTexture: String = "res://Scenes/ContentManager/Mapeditor/Images/emptyTile.png"
const aboveTexture: String = "res://Scenes/ContentManager/Mapeditor/Images/tileAbove.png"
const npcTexture: String = "res://Scenes/ContentManager/Mapeditor/Images/npctile.png"
const areaTexture: String = "res://Scenes/ContentManager/Mapeditor/Images/areatile.png"

signal tile_clicked(clicked_tile: Control)


# Emits tile_clicked signal when left mouse button is pressed
func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		tile_clicked.emit(self)


# Gets the rotation amount of the tile sprite
func get_rotation_amount() -> int:
	return $TileSprite.rotation_degrees


# Sets the scale amount for the tile sprite
func set_scale_amount(scaleAmount: int) -> void:
	custom_minimum_size.x = scaleAmount
	custom_minimum_size.y = scaleAmount


# If the user holds the mouse button while entering this tile, we consider it clicked
func _on_texture_rect_mouse_entered() -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		tile_clicked.emit(self)


func highlight() -> void:
	$TileSprite.modulate = Color(0.227, 0.635, 0.757)


func unhighlight() -> void:
	$TileSprite.modulate = Color(1, 1, 1)


func set_clickable(clickable: bool):
	if !clickable:
		mouse_filter = MOUSE_FILTER_IGNORE
		$TileSprite.mouse_filter = MOUSE_FILTER_IGNORE
		$ObjectSprite.mouse_filter = MOUSE_FILTER_IGNORE
		$AreaSprite.mouse_filter = MOUSE_FILTER_IGNORE


func _on_texture_rect_resized():
	$TileSprite.pivot_offset = size / 2
	$ObjectSprite.pivot_offset = size / 2
	$AreaSprite.pivot_offset = size / 2


func get_tile_texture():
	return $TileSprite.texture


# Sets the tooltip for this tile. The user can use this to see what's on this tile.
func set_tooltip(tileData: Dictionary) -> void:
	var tooltiptext = "Tile Overview:\n"

	# Display tile ID
	var tile_id: String = tileData.get("id", "")
	if tile_id == "":
		tooltiptext += "ID: None\n"
	else:
		tooltiptext += "ID: " + tile_id + "\n"

	# Display tile rotation
	tooltiptext += "Rotation: " + str(tileData.get("rotation", 0)) + " degrees\n"

	# Display feature information
	if tileData.has("feature"):
		var feature: Dictionary = tileData.feature
		var feature_type: String = feature.get("type", "None")
		tooltiptext += "Feature Type: " + feature_type + "\n"
		match feature_type:
			"mob", "mobgroup", "furniture":
				tooltiptext += "Feature ID: " + str(feature.get("id", "")) + "\n"
				tooltiptext += "Feature Rotation: " + str(feature.get("rotation", 0)) + " degrees\n"
				if feature_type == "furniture" and feature.has("itemgroups"):
					tooltiptext += "Furniture Item areas: " + str(feature.itemgroups) + "\n"
			"itemgroup":
				tooltiptext += "Itemgroups: " + str(feature.get("itemgroups", [])) + "\n"
				tooltiptext += "Feature Rotation: " + str(feature.get("rotation", 0)) + " degrees\n"
	else:
		tooltiptext += "Feature: None\n"

	# Display areas information
	if tileData.has("areas"):
		tooltiptext += "Tile areas: "
		for area in tileData.areas:
			var rotation_text = " (" + str(area.get("rotation", 0)) + ")"  # Get rotation or default to 0
			tooltiptext += area.id + rotation_text + ", "
		tooltiptext = tooltiptext.rstrip(", ")  # Remove the last comma and space
		tooltiptext += "\n"
	else:
		tooltiptext += "Tile areas: None\n"

	# Set the tooltip
	self.tooltip_text = tooltiptext


# Sets the visibility of the area sprite based on the provided area name and visibility flag
func set_area_sprite_visibility(isvisible: bool) -> void:
	$AreaSprite.visible = isvisible


# Updates the tile visuals based on the provided data
# Tiledata can have: id, rotation, mob, furniture, itemgroup, and areas
func update_display(tileData: Dictionary = {}, selected_area_name: String = "None"):
	var parent_name = get_parent().get_name()

	# Will be made visible again if the conditions are right
	$ObjectSprite.hide()
	$AreaSprite.hide()

	# If the parent node is "levelgrid_above", run the "set_above" logic
	if parent_name == "Level_Above":
		$ObjectSprite.texture = null
		if tileData.has("id") and tileData.id != "":
			$TileSprite.texture = load(aboveTexture)
		else:
			$TileSprite.texture = null
		return  # Exit early since we don't need to do further processing for the above layer

	# Regular update logic for other grids
	if tileData.has("id") and tileData["id"] != "" and tileData["id"] != "null":
		set_tile_id(tileData["id"])
		$TileSprite.rotation_degrees = tileData.get("rotation", 0)
		$ObjectSprite.rotation_degrees = 0
		$AreaSprite.rotation_degrees = 0

		if tileData.has("feature"):
			var feature: Dictionary = tileData.feature
			var feature_rot: int = int(feature.get("rotation", 0))
			match feature.get("type", ""):
				"mobgroup":
					$ObjectSprite.rotation_degrees = feature_rot
					$ObjectSprite.texture = (
						Gamedata
						. mods
						. get_content_by_id(DMod.ContentType.MOBGROUPS, feature.get("id", ""))
						. sprite
					)
					$ObjectSprite.show()
				"mob":
					$ObjectSprite.rotation_degrees = feature_rot
					$ObjectSprite.texture = (
						Gamedata
						. mods
						. get_content_by_id(DMod.ContentType.MOBS, feature.get("id", ""))
						. sprite
					)
					$ObjectSprite.show()
				"furniture":
					$ObjectSprite.rotation_degrees = feature_rot
					$ObjectSprite.texture = (
						Gamedata
						. mods
						. get_content_by_id(DMod.ContentType.FURNITURES, feature.get("id", ""))
						. sprite
					)
					$ObjectSprite.show()
				"npc_tile":
					$ObjectSprite.rotation_degrees = feature_rot
					$ObjectSprite.texture = load(npcTexture)
					$ObjectSprite.show()
				"itemgroup":
					set_tile_itemgroups(tileData)

		# Show the area sprite if conditions are met
		if tileData.has("areas") and selected_area_name != "None":
			for area in tileData["areas"]:
				if area["id"] == selected_area_name:
					$AreaSprite.show()
					break  # Exit the loop once the area is found
	else:
		$TileSprite.texture = load(defaultTexture)
		$ObjectSprite.texture = null

	set_tooltip(tileData)


# Update the sprite by id
func set_tile_id(id: String) -> void:
	if id == "null":
		return
	if id == "":
		$TileSprite.texture = load(defaultTexture)
	else:
		$TileSprite.texture = Gamedata.mods.get_content_by_id(DMod.ContentType.TILES, id).sprite


# Manages the itemgroups property for the tile.
# If the tile has no mob or furniture, it applies itemgroups to the tile and assigns a random sprite to the ObjectSprite.
# If the itemgroups array is empty, it hides the ObjectSprite and removes the itemgroups property from the tile.
# If the tileData contains a mob or furniture, the function returns early without making any changes.
func set_tile_itemgroups(tileData: Dictionary) -> void:
	if not tileData.has("feature"):
		return

	var feature: Dictionary = tileData.feature
	if feature.get("type", "") != "itemgroup":
		return

	var itemgroups: Array = feature.get("itemgroups", [])
	if itemgroups.is_empty():
		$ObjectSprite.hide()
	else:
		var random_itemgroup: String = itemgroups.pick_random()
		$ObjectSprite.texture = (
			Gamedata.mods.get_content_by_id(DMod.ContentType.ITEMGROUPS, random_itemgroup).sprite
		)
		$ObjectSprite.show()
		$ObjectSprite.rotation_degrees = 0
