extends AudioStreamPlayer

const level_music = preload("res://assets/sound/background.ogg")


func _play_music(music: AudioStream, volume = 0.0) -> void:
	if stream == music:
		return
	
	stream = music
	volume_db = volume


func _ready() -> void:
	play_music_level()


func play_music_level():
	_play_music(level_music)
	pass

func play_sound(_stream: AudioStream) -> void:
	var instance = AudioStreamPlayer.new()
	instance.stream = _stream
	instance.finished.connect(remove_node.bind(instance))
	add_child(instance)
	instance.volume_db = -5
	instance.play()


func remove_node(instance: AudioStreamPlayer) -> void:
	instance.queue_free()
