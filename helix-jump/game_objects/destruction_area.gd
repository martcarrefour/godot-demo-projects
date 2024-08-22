extends Area3D


func _on_body_entered(body: Node3D) -> void:
	#print("hi from area")
	var parent: Platform = get_parent()
	parent.bounse()
