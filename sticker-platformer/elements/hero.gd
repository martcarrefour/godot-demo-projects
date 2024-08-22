class_name Player
extends CharacterBody2D

## Player character with jumping and walking mechanics.
##
## Handles movement, jumping, and gravity for the player character,
## including double jump functionality and walk speed reduction.

@export var speed: float = 300.0
@export var jump_velocity: float = -350.0
@export var coyote_time: float = 0.2
@export var jump_buffer_time: float = 0.1
@export var fall_gravity_multiplier: float = 1.5
@export var reduced_jump_velocity_multiplier: float = 0.25
@export var accel: float = 5000.0
@export var decel: float = 10000.0
@export var max_jumps: int = 2
@export var has_double_jump: bool = true


var current_speed: float = 0.0
var coyote_timer: Timer
var jump_buffer_timer: Timer
var jumps_left: int = 0


func _ready() -> void:
	# Create and configure the coyote timer
	coyote_timer = Timer.new()
	coyote_timer.one_shot = true
	coyote_timer.wait_time = coyote_time
	add_child(coyote_timer)

	# Create and configure the jump buffer timer
	jump_buffer_timer = Timer.new()
	jump_buffer_timer.one_shot = true
	jump_buffer_timer.wait_time = jump_buffer_time
	add_child(jump_buffer_timer)

	# Initialize jumps if double jump is enabled
	if has_double_jump:
		jumps_left = max_jumps
	else:
		jumps_left = 1


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_jump()
	handle_movement(delta)

	var was_on_floor = is_on_floor()

	move_and_slide()

	if was_on_floor and not is_on_floor() and not Input.is_action_just_pressed("jump"):
		coyote_timer.start()

	if is_on_floor():
		reset_jumps()


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += jump_gravity(velocity) * delta
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= reduced_jump_velocity_multiplier


func jump_gravity(velocity: Vector2) -> Vector2:
	if velocity.y < 0:
		return get_gravity()
	return get_gravity() * fall_gravity_multiplier


func handle_jump() -> void:
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer.start()

	if (is_on_floor() or not coyote_timer.is_stopped() or jumps_left > 0) and not jump_buffer_timer.is_stopped():
		velocity.y = jump_velocity
		jump_buffer_timer.stop()
		jumps_left -= 1


func handle_movement(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		current_speed = move_toward(current_speed, direction * speed, accel * delta)
	else:
		current_speed = move_toward(current_speed, 0, decel * delta)
	
	velocity.x = current_speed

func reset_jumps() -> void:
	if has_double_jump:
		jumps_left = max_jumps
	else:
		jumps_left = 1


func enable_double_jump(enabled: bool) -> void:
	has_double_jump = enabled
	reset_jumps()
