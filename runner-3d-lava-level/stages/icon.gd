extends Sprite2D



func _on_color_picker_button_2_color_changed(color: Color) -> void:
	material.set_shader_parameter("color", color)
