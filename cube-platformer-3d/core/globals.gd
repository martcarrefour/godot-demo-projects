extends Node

var coins: int = 0


func _ready() -> void:
	Events.coin_picked.connect(add_coin)


func add_coin():
	coins += 1
