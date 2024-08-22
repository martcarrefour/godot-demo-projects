extends CharacterBody3D

var speed: float
var size: Vector3 = Vector3.ONE
const SPRINT_SPEED := 8.0
const WALK_SPEED := 5.0
const JUMP_VELOCITY := 4.5
const SENSITIVITY := 0.015
const MIN_SIZE := 0.1 * Vector3.ONE
const NORMAL_SIZE := Vector3.ONE

var red_visible = true
var green_visible = true
var blue_visible = true

@onready var head: Node3D = $Head
@onready var head_camera: Camera3D = %HeadCamera
@onready var camera: Camera3D = head_camera

#bob variables
const BOB_FREQ := 2.0
const BOB_AMP := 0.08
var t_bob := 0.0

#fov variables
const BASE_FOV := 75.0
const FOV_CHANGE := 1.5


func _update_color_visibility() -> void:
	if Input.is_action_just_pressed("color_1"):
		red_visible = !red_visible

		_set_group_visibility("RED", red_visible)
	elif Input.is_action_just_pressed("color_2"):
		green_visible = !green_visible
		_set_group_visibility("GREEN", green_visible)
	elif Input.is_action_just_pressed("color_3"):
		blue_visible = !blue_visible
		_set_group_visibility("BLUE", blue_visible)


func _set_group_visibility(group_name: String, visibility: bool) -> void:
	var nodes = get_tree().get_nodes_in_group(group_name)
	for node in nodes:
		node.visible = visibility


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))


func _physics_process(delta: float) -> void:
	# Quit game
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()

	# Color changer
	_update_color_visibility()

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle size change.
	if Input.is_action_just_pressed("change_size"):
		_change_size()
		scale = size

	# Handle sprint.
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)

	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 8.0)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

	move_and_slide()


func _headbob(time: float) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos


func _change_size() -> void:
	if size == MIN_SIZE:
		size = NORMAL_SIZE
	else:
		size = MIN_SIZE
