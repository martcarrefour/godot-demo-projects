extends CanvasLayer

@onready var coins_count: Label = %CoinsCount



func _ready() -> void:
	coins_count.text = str(Globals.coins)
	Events.coin_picked.connect(update_coins_count)


func update_coins_count() -> void:
	coins_count.text = str(Globals.coins)
