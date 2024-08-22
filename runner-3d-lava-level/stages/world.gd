extends Node3D

@onready var timer: Timer = $Timer
@onready var label: Label = %Label



var elapsed_time: float = 0.0

func _ready() -> void:
	timer.wait_time = 0.01  # таймер тикает каждые 10 миллисекунд
	timer.start()

func _process(delta: float) -> void:
	# Добавляем прошедшее время к общему времени
	elapsed_time += delta
	# Конвертируем время в минуты, секунды и сотые доли секунды
	var minutes: int = int(elapsed_time) / 60
	var seconds: int = int(elapsed_time) % 60
	var centiseconds: int = int((elapsed_time - int(elapsed_time)) * 100)
	# Обновляем текст метки
	label.text = String("%d:%02d.%02d" % [minutes, seconds, centiseconds])

func _on_dead_end_body_entered(body: Node3D) -> void:
	get_tree().reload_current_scene()
