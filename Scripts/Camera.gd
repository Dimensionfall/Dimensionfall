extends Camera3D

var can_zoom: bool = true
@export var player: Player = null

# Current default near value
const DEFAULT_NEAR = 18.601
const BUFF = -0.001
# The threshold for snapping back to default near value
const Y_THRESHOLD = 0.5

func _ready():
	# We connect to the inventory visibility change to interrupt zooming
	Helper.signal_broker.inventory_window_visibility_changed.connect(_on_inventory_visibility_change)

func _input(event):
	if event.is_action_pressed("zoom_in") and can_zoom:
		if(fov > 10):
			fov -= 5
			
	if event.is_action_pressed("zoom_out") and can_zoom:
		if(fov < 75):
			fov += 5

# Stop zooming when the inventory becomes visible
func _on_inventory_visibility_change(inventory_window):
	can_zoom = not inventory_window.visible

func _process(_delta):
	# Correct for the camera offset (since the camera is a child of the player)
	var corrected_position: float = player.global_position.y - 0.601
	
	# ✅ Custom snapping function based on Y_THRESHOLD
	var decimal_part = corrected_position - floor(corrected_position)
	var snapped_y_level = floor(corrected_position)

	if decimal_part >= Y_THRESHOLD:
		snapped_y_level = ceil(corrected_position)
	
	
	#var snapped_y_level = round(corrected_position)
	var y_offset = corrected_position - snapped_y_level
	
	# Gradually adjust near value based on y_offset until the threshold is reached
	if abs(y_offset) >= Y_THRESHOLD:
		# If the player crosses the threshold, snap back to default near value
		near = DEFAULT_NEAR
	else:
		# Adjust near value smoothly based on y_offset from snapped level
		near = BUFF + DEFAULT_NEAR + y_offset#(y_offset / Y_THRESHOLD)
	
