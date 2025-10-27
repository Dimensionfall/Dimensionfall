extends Node3D

@onready var projectiles_container : Node = $Projectiles

func _init():
	Helper.signal_broker.projectile_spawned.connect(_on_projectile_spawned)

# Add spawned projectiles to the dedicated container
func _on_projectile_spawned(projectile: Node, _instigator: RID) -> void:
	projectiles_container.add_child(projectile)
