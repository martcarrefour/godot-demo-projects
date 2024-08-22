extends CharacterBody2D

@onready var attack_component: AttackComponent = $AttackComponent as AttackComponent
@onready var health_component: HealthComponent = $HealthComponent as HealthComponent
@onready var loot_component: Node = $LootComponent as LootComponent
@onready var animation: AnimatedSprite2D = $Animation


func _ready() -> void:
	health_component.dead.connect(on_dead)


func on_dead() -> void:
	animation.play("Dead")
	await animation.animation_finished
	queue_free()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		print("ih")
		attack_component.attack()
