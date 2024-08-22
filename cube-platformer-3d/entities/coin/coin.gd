extends MeshInstance3D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var active:bool = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if !active:return
	
	audio_stream_player.play()
	if body:
		Events.coin_picked.emit()
	
	hide() 
	active = false
