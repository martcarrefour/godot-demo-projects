extends Node3D
class_name Platform


func bounse() -> void:
	for chield in get_children():
		queue_free()
