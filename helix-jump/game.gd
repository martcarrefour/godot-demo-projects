extends Node3D

@onready var tower: Node3D = $Tower
@export var rotation_speed: float = 0.01 

var touch_start_position: Vector2
var is_touching: bool = false


func _input(event: InputEvent) -> void:
	Input.emulate_touch_from_mouse = true

	if event is InputEventScreenTouch:
		if event.pressed:
			touch_start_position = event.position
			is_touching = true
		else:
			is_touching = false

	if event is InputEventScreenDrag and is_touching:
		var touch_current_position = event.position
		var touch_delta = touch_current_position - touch_start_position
		_rotate(touch_delta.x)
		touch_start_position = touch_current_position


func _rotate(delta: float) -> void:
	var velocity = delta * rotation_speed
	tower.rotate_y(velocity)
