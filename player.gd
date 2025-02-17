extends Node3D

@export var fixed_y: float = 1.5  # Y position the cube should stay at
@onready var below_ray = $RayCast3D

var current_collider

func _process(_delta):
	var mouse_world_pos = get_mouse_world_position()
	
	get_colliders()
		
	if mouse_world_pos:
		position = mouse_world_pos  # Move cube directly to the mouse position


func get_mouse_world_position() -> Vector3:
	var camera = get_viewport().get_camera_3d()
	if not camera:
		return Vector3()
	
	# Get mouse position in screen space
	var mouse_pos = get_viewport().get_mouse_position() 
	mouse_pos.y = get_viewport().get_mouse_position().y - 15
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


func get_colliders(): 
	if below_ray.is_colliding(): 
		var collider = below_ray.get_collider()
		if collider.is_in_group("Block"):
			if current_collider != null: 
				if current_collider != collider: 
					change_tile_colour(current_collider, current_collider.colour)
					
			current_collider = collider
			change_tile_colour(collider, Color("e8af7e"))
	else: 
		if current_collider != null: 
			change_tile_colour(current_collider, current_collider.colour)
		current_collider = null

func _unhandled_input(event:InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and current_collider != null and event.pressed:
			current_collider.place_unit()
			pass

func change_tile_colour(collider, colour): 
	var block = collider
	var mesh  = collider.get_child(0)
	var mesh_inst = mesh.mesh
	
	var 	material = StandardMaterial3D.new()
	material.albedo_color = colour
	mesh.material_override = material
