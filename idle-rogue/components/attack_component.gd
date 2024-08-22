extends Node
class_name AttackComponent

@export var attack_speed: float = 1.0
@export var speed_accuracy: float = 0.2
@export var damage: float = 1.0
@export var damage_accuracy: float = 0.2
@export var random_attack: bool = false
@export var auto_attack: bool = false

var target: CharacterBody2D = null

@export_subgroup("Antagonist")
@export var antagonist: int = 0

var group_names: Dictionary = {0: "enemys", 1: "heroes"}

var attack_timer: Timer


func _ready() -> void:
	attack_timer = Timer.new()
	attack_timer.one_shot = true
	add_child(attack_timer)
	attack_timer.timeout.connect(self._on_attack_timer_timeout)

	if auto_attack:
		start_attack_timer()


func find_target() -> void:
	var group_name: String = group_names[antagonist]
	var enemies = get_tree().get_nodes_in_group(group_name)
	var alive_enemies = []

	for enemy in enemies:
		if enemy.has_node("HealthComponent"):
			var health_component: HealthComponent = enemy.get_node("HealthComponent")
			if health_component and !health_component.is_dead:
				alive_enemies.append(enemy)


	if alive_enemies.size() == 0:
		return

	if target == null or !random_attack:
		target = alive_enemies[randi() % alive_enemies.size()]


func attack() -> void:
	find_target()
	var min_damage = damage * (1 - damage_accuracy)
	var max_damage = damage * (1 + damage_accuracy)
	damage = randf_range(min_damage, max_damage)

	if target != null:
		target.health_component.damage(damage)


func start_attack_timer() -> void:
	var min_time = attack_speed * (1 - speed_accuracy)
	var max_time = attack_speed * (1 + speed_accuracy)
	attack_timer.wait_time = randf_range(min_time, max_time)
	attack_timer.start()


func _on_attack_timer_timeout() -> void:
	attack()
	if auto_attack:
		start_attack_timer()
