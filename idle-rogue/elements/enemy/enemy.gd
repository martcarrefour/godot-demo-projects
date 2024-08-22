extends CharacterBody2D
class_name Enemy

@onready var attack_component: AttackComponent = $AttackComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var loot_component: LootComponent = $LootComponent
@onready var animation: AnimatedSprite2D = $Animation

@export var loot_gold: int = 0

var is_dead: bool = false


func _ready() -> void:
	health_component.dead.connect(on_dead)
	loot_component.gold = loot_gold


func on_dead() -> void:
	is_dead = true
	animation.play("Dead")
	Globals.add_gold(loot_component.gold)
	await animation.animation_finished
	queue_free()
