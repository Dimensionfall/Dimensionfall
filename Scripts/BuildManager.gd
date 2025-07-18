class_name BuildManager
extends Node3D

@export var construction_ghost: MeshInstance3D
var is_building = false
var construction_type: String = "block"
var construction_choice: String = ""

@export var level_generator: Node3D
@export var hud: NodePath

func _ready():
	# Connect the build menu visibility_changed signal to a local method
	if not Helper.signal_broker.build_window_visibility_changed.is_connected(_on_build_menu_visibility_change):
		Helper.signal_broker.build_window_visibility_changed.connect(_on_build_menu_visibility_change)
	if not Helper.signal_broker.construction_chosen.is_connected(_on_hud_construction_chosen):
		Helper.signal_broker.construction_chosen.connect(_on_hud_construction_chosen)

func _process(_delta):
	if is_building:
		construction_ghost.visible = true

func _input(event: InputEvent):
	if event.is_action_pressed("click_right") and is_building:
		cancel_building()

func cancel_building():
	is_building = false
	General.is_allowed_to_shoot = true
	construction_ghost.visible = false
	construction_type = ""
	construction_choice = ""

# When the user selects an option in the BuildingMenu.tscn scene
# type: One of "block" or "furniture". Choice: can be "concrete_wall" or some furniture id
func _on_hud_construction_chosen(type: String, choice: String):
	construction_type = type
	construction_choice = choice
	update_construction_ghost()  # Update the ghost based on the new selection
	start_building()


func start_building():
	is_building = true
	General.is_allowed_to_shoot = false
	construction_ghost.visible = true
	print_debug("Start building: type = ", construction_type, ", choice = ", construction_choice)


# Connects from the ConstructionGhost.gd script. 
# Example construction data: {"pos": global_transform.origin}
func on_construction_clicked(construction_data: Dictionary):
	# Ensure construction_type and construction_choice are set
	if construction_type == "" or construction_choice == "":
		print_debug("Construction type or choice is not set. Aborting.")
		return

	var chunk: Chunk = level_generator.get_chunk_from_position(construction_data.pos)
	if not chunk:
		return

	match construction_type:
		"block":
			handle_block_construction(construction_data, chunk)
		"furniture":
			handle_furniture_construction(construction_data, chunk)
		_:
			print_debug("Unknown construction type: ", construction_type)

func handle_block_construction(construction_data: Dictionary, chunk: Chunk) -> void:
	var numberofplanks: int = ItemManager.get_accessibleitem_amount("plank_2x4")
	if numberofplanks < 2:
		print_debug("Tried to construct, but not enough planks")
		return

	if not ItemManager.remove_resource("plank_2x4", 2, ItemManager.allAccessibleItems):
		return

	var local_position = calculate_local_position(construction_data.pos, chunk.position)
	chunk.add_block("concrete_00", local_position)
	print_debug("Block placed at local position: ", local_position, " in chunk at ", chunk.position, " with type concrete_00")

func handle_furniture_construction(construction_data: Dictionary, chunk: Chunk) -> void:
	construction_data.pos.y -= 1
	# Because Godot can be strange with rotation sometimes we have to translate the rotation
	var myrotation = construction_data.rotation
	if myrotation == 90:
		myrotation = 270
	elif myrotation == 270:
		myrotation = 90

	# Translate the position to negate the chunk's `mypos`
	construction_data.pos -= chunk.mypos

	# Spawn the furniture with the adjusted position
	chunk.spawn_furniture({
		"json": {"id": construction_choice, "rotation": myrotation, "mode": "blueprint"},
		"pos": construction_data.pos
	})

	print_debug(
		"Furniture construction chosen. Type: ", construction_type,
		", Choice: ", construction_choice,
		", Adjusted construction_data.pos: ", str(construction_data.pos)
	)


func calculate_local_position(global_pos: Vector3, chunk_pos: Vector3) -> Vector3:
	# Calculate local position within the chunk
	var local_x = int(global_pos.x - chunk_pos.x) % 32
	var local_z = int(global_pos.z - chunk_pos.z) % 32
	return Vector3(local_x, global_pos.y, local_z)

func _on_build_menu_visibility_change(buildmenu):
	print_debug("Build menu visibility changed: ", buildmenu.is_visible())
	if buildmenu.is_visible():
		if !is_building:
			var selection: Dictionary = buildmenu.get_selected_type_and_choice()
			construction_type = selection.type
			construction_choice = selection.choice
			update_construction_ghost()
			start_building()
		else:
			set_building_state(true)
	else:
		set_building_state(false)

func set_building_state(isvisible: bool):
	construction_ghost.visible = isvisible
	is_building = isvisible
	if not isvisible:
		General.is_allowed_to_shoot = true
	print_debug("Set building state: ", isvisible)


# Updates the material of the construction ghost based on the construction type and choice
func update_construction_ghost():
	construction_ghost.reset_to_default() # Resets size, rotation, material, offset
	if construction_type == "furniture":
		# Get the RFurniture instance by its ID
		var rfurniture: RFurniture = Runtimedata.furnitures.by_id(construction_choice)
		if rfurniture:
			# Retrieve the sprite material and set it to the construction ghost
			var furniture_sprite_material: StandardMaterial3D = Runtimedata.furnitures.get_standard_material_by_id(construction_choice)
			construction_ghost.set_material(furniture_sprite_material)
			construction_ghost.set_mesh_size(calculate_furniture_size(rfurniture))
			if not rfurniture.edgesnapping == "None":
				construction_ghost.set_position_offset(rfurniture.edgesnapping)
		else:
			print_debug("RFurniture with ID ", construction_choice, " not found. Resetting material.")
	else:
		# Handle unknown construction types by resetting to the default material
		print_debug("Unknown construction type: ", construction_type, ". Resetting material.")


# Function to calculate the size of the furniture
func calculate_furniture_size(rfurniture: RFurniture) -> Vector2:
	var sprite_texture = rfurniture.sprite
	if sprite_texture:
		var sprite_width = sprite_texture.get_width() / 100.0 # Convert pixels to meters
		var sprite_depth = sprite_texture.get_height() / 100.0 # Convert pixels to meters
		return Vector2(sprite_width, sprite_depth)  # Use height from support shape
	return Vector2(0.5, 0.5)  # Default size if texture is not set
