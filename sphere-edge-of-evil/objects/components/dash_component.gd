extends Node2D

@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown: Timer = $DashCooldown

func start_dash(duration: float):
	if can_dash():
		dash_timer.wait_time = duration
		dash_timer.start()
		start_dash_cooldown()
	
func is_dashing() -> bool:
	return !dash_timer.is_stopped()

func start_dash_cooldown():
	dash_cooldown.start()

func is_dash_on_cooldown() -> bool:
	return !dash_cooldown.is_stopped()

func can_dash() -> bool:
	return !is_dashing() and !is_dash_on_cooldown()
