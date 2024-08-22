extends Button
class_name SmileButton

@onready var label: Label = $Button/Label
@onready var animation: AnimationPlayer = $Button/AnimationPlayer as AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var index: int
var last: String


func _ready() -> void:
	label.text = last


func _on_button_down() -> void:
	audio_stream_player.play()
	Events.image_changed.emit(index)
	animation.play("Press")


func _on_button_up() -> void:
	animation.play_backwards("Press")
