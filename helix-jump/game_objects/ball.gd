extends RigidBody3D

@export var _jump_force := 5.0

# Called when the node enters the scene tree for the first time.

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	# Check for collisions
	if state.get_contact_count() > 0:
		state.linear_velocity = Vector3.ZERO
		
		state.apply_central_impulse(Vector3.UP * _jump_force)
