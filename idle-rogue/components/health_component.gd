extends Node
class_name HealthComponent

@onready var health_bar: ProgressBar = $Control/HealthBar
@onready var damage_number_origin: Node2D = $DamageNumberOrigin

signal dead
signal damaged(damaged_amount)
signal healed(health_amount)

@export var max_health: float

var current_health: float:
	get:
		return round(_current_health)
	set(value):
		_current_health = value

var _current_health: float = 0.0

var is_dead: bool = false


func _ready() -> void:
	if max_health == 0:
		printerr("Did not set health for " + owner.name)
		return
	current_health = max_health
	health_bar.value = current_health


func damage(attack_damage: float):
	current_health = maxf(0.0, current_health - attack_damage)
	Globals.display_number(attack_damage, damage_number_origin.global_position)
	if current_health <= 0:
		if not is_dead: 
			is_dead = true
			dead.emit()
	else:
		damaged.emit(attack_damage)

	health_bar.value = current_health


func heal(heal_amount: float):
	if is_dead:
		return
	current_health = minf(max_health, current_health + heal_amount)
	healed.emit(heal_amount)
	health_bar.value = current_health
