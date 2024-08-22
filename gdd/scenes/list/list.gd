extends VBoxContainer
class_name QuestionsList

const TEXT_INPUT_FIELD = preload("res://scenes/components/text_input/text_input_field.tscn")

@onready var page: PageResource


func _ready() -> void:
	for question in page.questions:
		if question:
			var input: TextInput = TEXT_INPUT_FIELD.instantiate()
			input.question = question
			add_child(input)
