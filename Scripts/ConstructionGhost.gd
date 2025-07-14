extends MeshInstance3D

# This script belongs to the ConstructionGhost node in the level_generation.tscn scene
# This script controls the constructionghost for the player so it will aid him in constructing something

# Reference to the player node
@export var player: Node3D
@export var buildmanager: Node3D
@export var construction_ghost_area_3d: Area3D = null
@export var construction_ghost_collision_shape_3d: CollisionShape3D = null

const CONSTRUCTION_GHOST_MATERIAL: Material = preload("res://Defaults/Blocks/Materials/construction_ghost_material.tres")

# Settings
var grid_size = 1.0
var y_offset = 0.0  # Offset relative to the player's position in the Y-axis
var build_range = 5.0  # Maximum build range from the player
var construction_data: Dictionary
# Offset for the ConstructionGhost's position
var position_offset: Vector3 = Vector3.ZERO
var has_obstacle: bool = false # Tracks whether there is an obstacle
var current_rotation: int = 0

signal construction_clicked(data: Dictionary)

func _ready():
	# Connect the signal for construction clicks to the build manager
	construction_clicked.connect(buildmanager.on_construction_clicked)
	visibility_changed.connect(_on_visibility_changed)


func _process(_delta):
	if !visible:
		return

	# Get the 3D position from the mouse's 2D position on the screen
	var mouse_position = get_mouse_3d_position()
	
	# Ensure the position stays within the build range from the player
	var x_diff = mouse_position.x - player.global_position.x
	var z_diff = mouse_position.z - player.global_position.z
	
	if x_diff > build_range:
		mouse_position.x = player.global_position.x + build_range
	elif x_diff < -build_range:
		mouse_position.x = player.global_position.x - build_range
		
	if z_diff > build_range:
		mouse_position.z = player.global_position.z + build_range
	elif z_diff < -build_range:
		mouse_position.z = player.global_position.z - build_range
	
	# Snap the position to the grid
	var snapped_x = round(mouse_position.x / grid_size) * grid_size
	var snapped_z = round(mouse_position.z / grid_size) * grid_size
	var snapped_y = round(mouse_position.y / grid_size) * grid_size
	
	# Update the position of the construction ghost with the offset applied
	global_transform.origin = Vector3(snapped_x, snapped_y, snapped_z) + position_offset
	construction_ghost_area_3d.global_transform.origin = Vector3(snapped_x, snapped_y+0.5, snapped_z)


# Calculate the 3D position based on the mouse's 2D position and the player's Y offset
func get_mouse_3d_position() -> Vector3:
	var mouse_position_2d = get_viewport().get_mouse_position()
	var plane = Plane(Vector3.UP, player.global_position.y + y_offset)
	var ray_origin = player.camera_3d.project_ray_origin(mouse_position_2d)
	var ray_direction = player.camera_3d.project_ray_normal(mouse_position_2d)
	var mouse_position = ray_origin + ray_direction * player.camera_3d.global_transform.origin.distance_to(plane.project(ray_origin))
	
	return Vector3(mouse_position.x, player.global_position.y + y_offset, mouse_position.z)


# Input handling to check for obstacles and other criteria before emitting the signal
func _input(event):
	if not visible:
		return

	# Handle left mouse button click for placing construction
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if has_obstacle:
			return
		construction_data = {"pos": global_transform.origin-position_offset, "rotation": current_rotation}
		construction_clicked.emit(construction_data)
	
	# Handle "r" key press for rotating the construction ghost
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_R:
		# Increment the current rotation by 90 degrees
		var new_rotation = (current_rotation + 90) % 360
		set_mesh_rotation(new_rotation)


# Sets the material of the ConstructionGhost
func set_material(new_material: Material) -> void:
	if mesh:
		mesh.surface_set_material(0, new_material)  # Assuming the ghost mesh has a single surface

# Resets the material to the default CONSTRUCTION_GHOST_MATERIAL
func reset_material_to_default() -> void:
	set_material(CONSTRUCTION_GHOST_MATERIAL)


# Sets the size of the ConstructionGhost mesh, which is a PlaneMesh
func set_mesh_size(size: Vector2) -> void:
	if mesh:
		mesh.set_size(size)

# Resets the size of the ConstructionGhost mesh to the default size (Vector2(1, 1))
func reset_mesh_size_to_default() -> void:
	set_mesh_size(Vector2(1, 1))


func apply_edge_snapping(direction: String) -> Vector3:
	# Block size, each block is 1x1 meter
	var block_size = Vector3(1.0, 1.0, 1.0)
	var offset = Vector3.ZERO

	# Retrieve the furniture size from the mesh
	var furniture_size = mesh.size if mesh else Vector3.ONE

	# Adjust offset based on the edge-snapping direction
	match direction:
		"North":
			offset.z -= block_size.z / 2 - furniture_size.y / 2
		"South":
			offset.z += block_size.z / 2 - furniture_size.y / 2
		"East":
			offset.x += block_size.x / 2 - furniture_size.x / 2
		"West":
			offset.x -= block_size.x / 2 - furniture_size.x / 2
		_:
			pass  # No adjustment for undefined directions

	# Apply rotation to the offset
	offset = rotate_offset_around_center(offset)

	return offset

# Function to apply rotation to the offset
func rotate_offset_around_center(offset: Vector3) -> Vector3:
	var myrotation = current_rotation
	if myrotation == 90:
		myrotation = 270
	elif myrotation == 270:
		myrotation = 90
	var radians = deg_to_rad(myrotation)  # Convert current rotation to radians
	return Vector3(
		offset.x * cos(radians) - offset.z * sin(radians),  # Rotate XZ plane
		offset.y,                                           # Y remains unchanged
		offset.x * sin(radians) + offset.z * cos(radians)
	)


var edge_snapping_direction: String
# Sets the position offset of the ConstructionGhost
func set_position_offset(my_direction: String = "") -> void:
	edge_snapping_direction = my_direction
	# Reset the position offset
	position_offset = Vector3.ZERO

	# Apply edge snapping if direction is provided
	if edge_snapping_direction != "":
		position_offset += apply_edge_snapping(edge_snapping_direction)


# Resets the position offset of the ConstructionGhost
func reset_position_offset_to_default() -> void:
	# Reset the offset to zero (default)
	position_offset = Vector3.ZERO

# Sets the rotation of the ConstructionGhost mesh
func set_mesh_rotation(new_rotation: int) -> void:
	# Update the current rotation
	current_rotation = new_rotation % 360

	print_debug("ConstructionGhost rotation: ", current_rotation)

	# Update the ghost's rotation
	rotation_degrees.y = current_rotation

	# Recalculate the position offset based on the new rotation
	set_position_offset(edge_snapping_direction)


# Resets the rotation of the ConstructionGhost mesh to the default (no rotation)
func reset_rotation_to_default() -> void:
	# Reset the rotation to 0
	set_mesh_rotation(0)


# Called when a body enters the construction ghost's area
func _on_construction_ghost_area_3d_body_entered(body: Node3D) -> void:
	# Mark that an obstacle is present
	has_obstacle = true

# Called when a body exits the construction ghost's area
func _on_construction_ghost_area_3d_body_exited(body: Node3D) -> void:
	# Check if no other obstacles remain in the area
	if construction_ghost_area_3d.get_overlapping_bodies().size() == 0:
	has_obstacle = false

# Logs visibility changes
func _on_visibility_changed() -> void:
	print_debug("ConstructionGhost visibility: ", visible)

func reset_to_default():
	reset_rotation_to_default()
	reset_position_offset_to_default()
	reset_mesh_size_to_default()
	reset_material_to_default()
