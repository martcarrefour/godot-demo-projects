extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var dash: Node2D = $DashComponent
@export var speed = 100.0

const PROJECTILE = preload("res://objects/attacks/projectile.tscn")
const dash_speed = 800
const dash_lenght = .1
const DAMAGE_COMPONENT = preload("res://objects/components/damage_component.tscn")
const HEAL_COMPONENT = preload("res://objects/components/heal_component.tscn")

func _physics_process(_delta: float) -> void:
	_attack()
	_move()
	#_select_target()
	move_and_slide()



#func _select_target() -> void:
#
	#if Input.is_action_just_pressed("rig"):
		#print("right click")




func _create_projectile(effect_component: PackedScene) -> void:
	var projectile: Attack = PROJECTILE.instantiate()
	projectile.add_child(effect_component.instantiate())
	var mouse_position = get_global_mouse_position()
	
	# Устанавливаем начальную позицию снаряда в текущую позицию игрока
	projectile.global_position = global_position

	# Вычисляем направление движения снаряда
	projectile.direction = (mouse_position - global_position).normalized()

	# Добавляем снаряд как независимого ребенка сцены
	get_parent().add_child(projectile)

func _attack() -> void:
	if Input.is_action_just_pressed("left_mouse"):
		_create_projectile(DAMAGE_COMPONENT)
		
	if Input.is_action_just_pressed("right_mouse"):
		_create_projectile(HEAL_COMPONENT)
		

func _move() -> void:
	if Input.is_action_just_pressed("dash"):
		dash.start_dash(dash_lenght)
	var speed = dash_speed if dash.is_dashing() else speed

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

	if direction.x > 0:
		sprite.flip_h = true
	elif direction.x < 0:
		sprite.flip_h = false
