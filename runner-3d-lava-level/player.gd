extends CharacterBody3D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var stamina_bar: ProgressBar = %StaminaBar

@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var coyote_time: float = 0.2
@export var jump_buffer_time: float = 0.1
@export var fall_gravity_multiplier: float = 1.5
@export var reduced_jump_velocity_multiplier: float = 0.25
@export var accel: float = 5000.0
@export var decel: float = 10000.0
@export var max_jumps: int = 2
@export var has_double_jump: bool = true
@export var sensitivity: float = 0.015

@export var max_stamina: float = 10000.0  # Максимальное значение стамины
@export var stamina_regen_rate: float = 50.0  # Скорость восстановления стамины
@export var sprint_stamina_cost: float = 15.0  # Стоимость стамины за бег
@export var jump_stamina_cost: float = 20.0  # Стоимость стамины за прыжок

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/HeadCamera

var current_speed: float = 0.0
var coyote_timer: Timer
var jump_buffer_timer: Timer

var jumps_left: int = 0
var current_stamina: float = max_stamina  # Текущая стамина

# moving
const SPRINT_SPEED := 8.0
const WALK_SPEED := 5.0

# Bob variables
const BOB_FREQ := 2.0
const BOB_AMP := 0.08
var t_bob := 0.0

# FOV variables
const BASE_FOV := 75.0
const FOV_CHANGE := 1.5

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

	# Initialize stamina bar
	stamina_bar.max_value = max_stamina
	stamina_bar.value = current_stamina

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()

	if Input.is_action_pressed("sprint") and current_stamina > 0:
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_jump()
	handle_movement(delta)
	update_stamina(delta)

	var was_on_floor = is_on_floor()

	move_and_slide()

	if was_on_floor and not is_on_floor() and not Input.is_action_just_pressed("jump"):
		coyote_timer.start()

	if is_on_floor():
		reset_jumps()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * fall_gravity_multiplier * delta
	if Input.is_action_just_released("jump") and velocity.y > 0:
		velocity.y *= reduced_jump_velocity_multiplier

func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and current_stamina >= jump_stamina_cost:
		audio_stream_player.play()
		jump_buffer_timer.start()

	if (is_on_floor() or not coyote_timer.is_stopped() or jumps_left > 0) and not jump_buffer_timer.is_stopped() and current_stamina >= jump_stamina_cost:
		velocity.y = jump_velocity
		jump_buffer_timer.stop()
		jumps_left -= 1
		current_stamina -= jump_stamina_cost  # Уменьшаем стамину при прыжке

func handle_movement(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if is_on_floor():
		if direction:
			if $Timer.time_left <= 0:
				audio_stream_player.play()
				$Timer.start(0.2)

			velocity.x = move_toward(velocity.x, direction.x * speed, accel * delta)
			velocity.z = move_toward(velocity.z, direction.z * speed, accel * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, decel * delta)
			velocity.z = move_toward(velocity.z, 0, decel * delta)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)

	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 8.0)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

func update_stamina(delta: float) -> void:
	if speed == SPRINT_SPEED and current_stamina > 0:
		current_stamina -= sprint_stamina_cost * delta
	elif speed == WALK_SPEED:
		current_stamina += stamina_regen_rate * delta

	current_stamina = clamp(current_stamina, 0, max_stamina)
	stamina_bar.value = current_stamina

func _headbob(time: float) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

func reset_jumps() -> void:
	if has_double_jump:
		jumps_left = max_jumps
	else:
		jumps_left = 1

func enable_double_jump(enabled: bool) -> void:
	has_double_jump = enabled
	reset_jumps()
