extends Control

@onready var hat_view: TextureRect = $Pet/HatView
@onready var animation_player: AnimationPlayer = $Pet/AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $Pet/BarkButton/AudioStreamPlayer

var current_animation = "Idle"


func _ready() -> void:
	Events.hat_changed.connect(change_hat)


func change_hat(hat: CompressedTexture2D) -> void:
	hat_view.texture = hat


func _on_smile_button_pressed() -> void:
	animation_player.play("Smile")


func _on_bark_button_pressed() -> void:
	AudioManager.play_sound(audio_stream_player.stream)
	animation_player.play("Bark")
