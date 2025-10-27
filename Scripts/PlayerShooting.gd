extends Node3D

# Define properties for left-hand and right-hand weapons.
@export var left_hand_item: Sprite3D
@export var right_hand_item: Sprite3D

@onready var player: Node3D = get_parent()

# Count bullets spawned for testing.
var _bullet_count: int = 0


func _ready() -> void:
	Helper.signal_broker.projectile_spawned.connect(_on_projectile_spawned)
	PlayerInputSignalBroker.reload_weapon().connect(_on_reload_weapon)


func _on_projectile_spawned(projectile: Node, instigator: RID) -> void:
	if instigator == player.get_rid():
		_bullet_count += 1


func get_bullet_count() -> int:
	return _bullet_count


func reset_bullet_count() -> void:
	_bullet_count = 0


func _on_reload_weapon() -> void:
	if not left_hand_item or not right_hand_item:
		return
	if General.is_action_in_progress:
		return
	if left_hand_item.can_weapon_reload() and right_hand_item.can_weapon_reload():
		if left_hand_item.get_current_ammo() < right_hand_item.get_current_ammo():
			left_hand_item.reload_weapon()
		elif left_hand_item.get_current_ammo() > right_hand_item.get_current_ammo():
			right_hand_item.reload_weapon()
		else:
			if left_hand_item.can_weapon_reload():
				left_hand_item.reload_weapon()
			elif right_hand_item.can_weapon_reload():
				right_hand_item.reload_weapon()
	else:
		if left_hand_item.can_weapon_reload():
			left_hand_item.reload_weapon()
		elif right_hand_item.can_weapon_reload():
			right_hand_item.reload_weapon()
