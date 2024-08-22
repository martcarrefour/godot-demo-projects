extends Control

const LEVEL_1 = preload("res://objects/levels/level_1.tscn")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(LEVEL_1)
