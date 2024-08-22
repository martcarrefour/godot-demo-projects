extends Area2D
class_name HealthComponent

@export var max_health: float = 100
@onready var health_bar: ProgressBar = $HealthBar

signal dead
signal damaged(damaged_amount)
signal healed(health_amount)

var _current_health: float = 0.0

var current_health: float:
	get:
		return round(_current_health)
	set(value):
		_current_health = value
		update_health_bar()


func _ready() -> void:
	if max_health == 0:
		printerr("Did not set health for " + owner.name)
		return
	current_health = max_health
	update_health_bar()


func take_damage(value: float):

	current_health = maxf(0.0, current_health - value)
	if current_health <= 0:
		die()
		dead.emit()
	else:
		damaged.emit(value)


func heal(heal_amount: float):
	current_health = minf(max_health, current_health + heal_amount)
	healed.emit(heal_amount)


func die() -> void:
	get_parent().queue_free()



func update_health_bar() -> void:
	if health_bar:
		health_bar.value = current_health


func _on_body_entered(body: Node2D) -> void:
	if body.has_node("DamageComponent"):
		body.queue_free()
		var damage_compoennt = body.get_node("DamageComponent") as Damage
		take_damage(damage_compoennt.damage)
		
	if body.has_node("HealComponent"):
		body.queue_free()
		var heal_component = body.get_node("HealComponent") as Heal
		heal(heal_component.heal)
