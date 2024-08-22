extends GridContainer

const HATS_LIST = preload("res://assets/images/hats_list.tres")
const HAT_BUTTON = preload("res://components/hat/hat_button.tscn")
const HAT = preload("res://components/hat/hat.tscn")


func _ready() -> void:
	for hat_texture in HATS_LIST.hats:
		var new_button = HAT_BUTTON.instantiate()
		var new_hat = HAT.instantiate()
		new_hat.texture = hat_texture
		new_hat.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		new_button.add_child(new_hat)
		new_button.connect("pressed", func(): _hat_selected(hat_texture))
		add_child(new_button)


func _hat_selected(hat: CompressedTexture2D) -> void:
	Events.hat_changed.emit(hat)
