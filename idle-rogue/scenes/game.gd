extends Node2D

var heal_price: int = 100
@onready var hero: CharacterBody2D = $Hero
@onready var heal_button: Button = $HealButton
@onready var spawn_point: Marker2D = $SpawnPoint
@onready var enemys: Node2D = $Enemys
const ENEMY_SCENE = preload("res://elements/enemys/enemys.tscn")

func _ready() -> void:
	# Делаем кнопку лечения неактивной при запуске
	heal_button.disabled = true

func _process(delta: float) -> void:
	# Проверяем достаточно ли золота для активации кнопки лечения
	if Globals.gold >= heal_price:
		heal_button.disabled = false
	else:
		heal_button.disabled = true

	if not enemys:
		print("spewan5")
		spawn_enemys()
		
	if enemys.get_child_count() == 0:
		enemys.queue_free()

func spawn_enemys() -> void:
	var new_enemy = ENEMY_SCENE.instantiate()
	new_enemy.global_position = spawn_point.global_position
	add_child(new_enemy)
	enemys = new_enemy

func _on_heal_button_pressed() -> void:
	# Проверяем, достаточно ли золота для лечения
	if Globals.gold < heal_price:
		return
	
	# Снимаем золото и лечим героя
	Globals.add_gold(-heal_price)
	hero.health_component.heal(100)
