extends VBoxContainer
@onready var texture_rect: TextureRect = %TextureRect

const ARTS = [
	preload("res://assets/art/red.png"),
	preload("res://assets/art/yellow.png"),
	preload("res://assets/art/blue.png"),
	preload("res://assets/art/purple.png"),
	preload("res://assets/art/green.png"),
	preload("res://assets/art/pink.png"),
	preload("res://assets/art/black.png"),
	preload("res://assets/art/white.png"),
	preload("res://assets/art/default.png"),
	preload("res://assets/art/bg.png"),
]


func _ready() -> void:
	Events.image_changed.connect(change_image)


func change_image(i):
	if texture_rect.texture != ARTS[i]:
		texture_rect.texture = ARTS[i]
	else:
		texture_rect.texture = ARTS[9]



func _on_button_pressed() -> void:
	texture_rect.texture = ARTS[9]
