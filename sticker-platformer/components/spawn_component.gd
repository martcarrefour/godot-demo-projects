extends Node2D

const HERO = preload("res://elements/hero.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var hero: CharacterBody2D = HERO.instantiate() as CharacterBody2D
	
	get_parent().call_deferred("add_child", hero)
	hero.global_position = global_position
