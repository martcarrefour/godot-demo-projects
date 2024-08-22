extends Control
@onready var colors_resource: ColorsResource = ColorsResource.new()
const BUTTON = preload("res://scenes/objects/button.tscn")
const IMAGE = preload("res://scenes/objects/image.tscn")
@onready var color_button_container: GridContainer = %ColorButtonContainer
@onready var margin_container: MarginContainer = $MarginContainer


var buttons: Array = []

func _ready() -> void:
	var image = IMAGE.instantiate()
	margin_container.add_child(image)

	for i in range(colors_resource.colors.size()):
		var color = colors_resource.colors[i]
		var new_button: SmileButton = BUTTON.instantiate()
		new_button.index = i
		new_button.modulate = color
		if i == colors_resource.colors.size() - 1:
			new_button.last = "?"
		color_button_container.add_child(new_button)
		buttons.append(new_button)



func _input(event: InputEvent) -> void:
	for i in range(10):  # Проверка первых 10 клавиш (0-9)
		if Input.is_action_pressed("button_" + str(i + 1)):
			if i < buttons.size():
				buttons[i]._on_button_down()

		if Input.is_action_just_released("button_" + str(i + 1)):
			if i < buttons.size():
				buttons[i]._on_button_up()
