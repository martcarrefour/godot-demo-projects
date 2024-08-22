extends Node3D




func _on_dead_end_body_entered(_body: Node3D) -> void:
	get_tree().reload_current_scene()
