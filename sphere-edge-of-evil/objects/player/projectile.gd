extends CharacterBody2D
class_name Attack

@export var effect: Area2D 

@export var speed = 400
var direction: Vector2


func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	
	
