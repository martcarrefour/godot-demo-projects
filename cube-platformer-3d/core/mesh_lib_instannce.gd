@tool
extends MeshInstance3D
class_name  MeshLibInstance3D



@export var frames: MeshLibrary:
	set = set_frames
@export var current_frame: int:
	set = set_current_frame

var mesh_count: int = 0



func set_frames(v):
	frames = v
	current_frame = 0
	if v == null:
		mesh_count = 0
		self.mesh = null
	else:
		mesh_count = v.get_item_list().size()
		self.mesh = v.get_item_mesh(0)


func set_current_frame(v):
	if v >= 0 and v < mesh_count:
		current_frame = v
		self.mesh = frames.get_item_mesh(v)
