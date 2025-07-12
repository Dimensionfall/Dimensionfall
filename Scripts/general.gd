extends Node

# Existing variables
var is_mouse_outside_hud = false
var is_allowed_to_shoot = true

# For controlling the player actions
var is_action_in_progress = false
var action_timer: Timer
var action_complete_callback: Callable  # Use Callable to store the function reference
signal start_timer_progressbar(time_left: float)

# Shared shape for mobs
var shared_collision_shape = BoxShape3D.new()

## Initializes the action timer and connects signals.
func _ready():
	# Initialize the timer
	action_timer = Timer.new()
	action_timer.timeout.connect(_on_action_timer_timeout)
	add_child(action_timer)
	start_timer_progressbar.connect(Helper.signal_broker.on_start_timer_progressbar)
	shared_collision_shape.size = Vector3(0.35, 0.35, 0.35)

## Starts a timed action and runs `callback` when finished.

func start_action(duration: float, callback: Callable):
	if not is_action_in_progress:
		is_action_in_progress = true
		action_complete_callback = callback  # Store the callback function
		action_timer.start(duration)
		start_timer_progressbar.emit(duration)
		# Other necessary code to start the action
	else:
		print_debug("Another action is currently in progress.")

## Handles the completion of a timed action.
func _on_action_timer_timeout():
	is_action_in_progress = false
	# Call the callback function if it exists
	if action_complete_callback:
		var result = action_complete_callback.call()
		if result is bool and result == false:
			print_debug("Action callback returned failure.")
	# Reset the callback function
	action_complete_callback = Callable()
	# Code to handle the completion of the action


## Converts a string in the form "(x, y)" to a Vector2. Returns Vector2.ZERO if invalid.
static func string_to_vector2(input: Variant) -> Vector2:
	# If input is already a Vector2, return it as is
	if input is Vector2:
		return input
	
	# If input is a String, attempt to parse it
	if input is String and input != "":
		var new_string: String = input
		new_string = new_string.erase(0, 1)
		new_string = new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")

		return Vector2(int(array[0]), int(array[1]))

	# If input is invalid, return Vector2.ZERO
	return Vector2.ZERO
