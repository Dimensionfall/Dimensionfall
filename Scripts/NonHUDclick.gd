extends Control


func _on_mouse_entered():
	General.is_mouse_outside_hud = true


func _on_mouse_exited():
	General.is_mouse_outside_hud = false
