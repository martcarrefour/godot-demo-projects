extends TextureButton

@export var sound: AudioStream


func _on_pressed() -> void:
	AudioManager.play_sound(sound)
