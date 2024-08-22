extends CanvasLayer
@onready var texture_rect: TextureRect = $TextureRect


func _ready() -> void:
	Input.set_custom_mouse_cursor(texture_rect.texture, Input.CURSOR_ARROW)


func _process(delta: float) -> void:
	texture_rect.global_position = texture_rect.get_global_mouse_position()
