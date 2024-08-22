extends VBoxContainer
class_name TextInput

@export var label_text: String
@export var input_height: int
@export var input_mode := InputMode.ALL
var question: QuestionResource

enum InputMode { ALL, DIGITS_ONLY }

@onready var label: Label = $Label
@onready var text_input_field: TextEdit = $TextInputField


func _ready() -> void:
	label.text = question.question_text
	text_input_field.text = question.answer_text
	if input_height:
		text_input_field.custom_minimum_size.y = input_height
	text_input_field.set_input_mode(input_mode)


func _on_text_input_field_text_changed() -> void:
	question.answer_text = text_input_field.text
	Globals.update_current_save()
