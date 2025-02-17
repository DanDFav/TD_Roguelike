extends Node3D

@export var fixed_y: float = 1.5  # Y position the cube should stay at

var current_collider

func _process(_delta):
	pass
	var mouse_world_pos = get_mouse_world_position()
		
	if mouse_world_pos:
		position = mouse_world_pos  # Move cube directly to the mouse position


func get_mouse_world_position() -> Vector3:
	var camera = get_viewport().get_camera_3d()
	if not camera:
		return Vector3()
	
	# Get mouse position in screen space
	var mouse_pos = get_viewport().get_mouse_position() 
	mouse_pos.y = get_viewport().get_mouse_position().y 
	# Raycasting from the camera
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_dir = camera.project_ray_normal(mouse_pos)
	
	# Find intersection with the Y=2 plane
	var t = (fixed_y - ray_origin.y) / ray_dir.y  # Solve for Y=2
	if t < 0:
		return Vector3()  # Mouse is above or below the plane at Y=2
	
	# Compute world position at Y=2
	var world_pos = ray_origin + ray_dir * t
	
	# Directly set the position to be on the mouse position at Y=2
	return Vector3(world_pos.x, fixed_y, world_pos.z)
