extends CharacterBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera: Camera3D = $Camera3D

const SPEED = 5.0
const SPRINT_SPEED = 10.0
const JUMP_VELOCITY = 4.5
const DOUBLE_JUMP_VELOCITY = 3.5
const MOUSE_SENSITIVITY = 0.1

var yaw = 180.0
var pitch = 0.0
var can_double_jump = false


func _ready() -> void:
	rotation_degrees.y= yaw
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * MOUSE_SENSITIVITY
		# Обновление только горизонтального вращения камеры и персонажа
		rotation_degrees.y = yaw


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		can_double_jump = true

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY

			
		elif can_double_jump:
			animation_player.play("Rotation")
			velocity.y = DOUBLE_JUMP_VELOCITY
			can_double_jump = false

	# Handle exit
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	# Handle sprint.
	var current_speed = SPEED
	if Input.is_action_pressed("ui_shift"):
		current_speed = SPRINT_SPEED
		animation_player.speed_scale = 2.0  # Ускоряем анимацию в 2 раза
	else:
		animation_player.speed_scale = 1.0  # Возвращаем нормальную скорость анимации

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if is_on_floor():
			if direction:
				if $Timer.time_left <= 0:
					$AudioStreamPlayer.play()
					$Timer.start(0.3)
			
			animation_player.play("Run")

		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		animation_player.play("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
