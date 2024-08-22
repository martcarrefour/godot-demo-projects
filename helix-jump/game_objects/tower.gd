extends Node3D

@export var _level_count: int = 1
@export var _additional_beam_height: int = 10.0
@export var _packed_platforms: Array[PackedScene]

@onready var ball: RigidBody3D = $Ball
@onready var start_platform: CSGPolygon3D = $StartPlatform
@onready var finish_platform: CSGPolygon3D = $FinishPlatform
@onready var beam: CSGCylinder3D = $Beam

func _ready() -> void:
	beam.height = _level_count + _additional_beam_height
	start_platform.position = Vector3(0, _level_count / 2.0, 0)
	finish_platform.position = Vector3(0, -(_level_count / 2.0), 0)
	ball.position = start_platform.position + Vector3(0, 1, 0.8)
	_build()

func _build() -> void:
	var step_height = _level_count / float(_packed_platforms.size() + 1)
	for i in range(_packed_platforms.size()):
		var spawn_height = (i + 1) * step_height - (_level_count / 2.0)
		_spawn_platform(_packed_platforms[i], spawn_height)

func _spawn_platform(platform: PackedScene, spawn_height: float) -> void:
	var new_platform: Node3D = platform.instantiate()
	beam.add_child(new_platform)
	new_platform.global_position = Vector3(0, spawn_height, 0)
	new_platform.quaternion = Quaternion.from_euler(Vector3(0, randf_range(0, 360), 0))
	new_platform.scale = Vector3.ONE




func _on_area_3d_body_entered(body: Node3D) -> void:
	print("hi")
