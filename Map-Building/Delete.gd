extends Node

var map := [
			 [1, 1, 1, 1, 1, 1, 1, 1],
			 [1, 0, 0, 0, 0, 0, 0, 1],
			 [1, 0, 1, 1, 1, 1, 0, 1],
			 [1, 0, 1, 1, 1, 1, 0, 1],
			 [1, 0, 1, 1, 1, 1, 0, 1],
			 [1, 0, 1, 0, 0, 0, 0, 1],
			 [1, 2, 1, 3, 1, 1, 1, 1],
			 [1, 1, 1, 1, 1, 1, 1, 1]
		   ]

const BLOCK_SIZE := 0.5
var HALF_SHIFT_X := len(map[0]) / 2
var HALF_SHIFT_Z := len(map) / 2
var x_pos_base := BLOCK_SIZE - 0.25 + 0.5
var z_pos_base := BLOCK_SIZE + 0.25 + 0.5

var block_resource = preload("res://Map-Building/Blocks/Block.tscn")
var unit = preload("res://player.tscn")
var spawner_resource = preload("res://spawner.tscn")
var exit_resource = preload("res://exit.tscn")


func _ready() -> void:
	create_map()
	

func create_map(): 
	var center_block = find_center_block()
	add_child(unit.instantiate())
	
	for x in range(len(map)):
		var new_row = Node3D.new()
		add_child(new_row)
		for z in range(len(map[x])):
			var block_type = map[x][z]
			var is_center = false
			if x == center_block.x and z == center_block.y: 
				is_center = true
			if block_type == 1: 
				create_new_range_block(z, block_type, x, new_row, center_block, is_center)
			elif block_type == 0: 
				create_new_ground_block(z, block_type, x, new_row, center_block, is_center)
			elif block_type == 2: 
				create_new_special(z, block_type, x, center_block)
			elif block_type == 3: 
				create_new_special(z, block_type, x, center_block)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_new_special(x: int, y: int, z:int, length: Vector2): 
	var special
	if y == 2: 
		special = spawner_resource.instantiate()
	elif y == 3: 
		special = exit_resource.instantiate()
	
	#spawner.row = x
	#spawner.col = z
	
	var starting_x = x * BLOCK_SIZE - 0.25 + 0.5
	var starting_z = z * BLOCK_SIZE + 0.25 + 0.5
	
	var centering_val_x = length.y / 2
	var centering_val_z = length.x / 2
	
	special.position = Vector3(starting_x - centering_val_x, 1 * BLOCK_SIZE, starting_z - centering_val_z)
	
	add_child(special)
	

func create_new_range_block(x: int, y: int, z: int, row_inst: Node3D, length:Vector2 ,center: bool): 
	var range_block  = block_resource.instantiate()
	var RB_mesh      = range_block.get_child(0)
	var RB_collision = range_block.get_child(1)
	var RB_mesh_inst = RB_mesh.mesh.duplicate() 
	
	
	
	var 	RB_material = StandardMaterial3D.new()
	
	range_block.height = BLOCK_SIZE + 0.25
	range_block.colour = Color("ff4040")
	RB_material.albedo_color = Color("ff4040") #Red 

	RB_mesh.material_override = RB_material
	
	range_block.row = x
	range_block.col = z
	
	var starting_x = x * BLOCK_SIZE - 0.25 + 0.5
	var starting_z = z * BLOCK_SIZE + 0.25 + 0.5

	var centering_val_x = length.y / 2
	var centering_val_z = length.x / 2
	
	range_block.position = Vector3(starting_x - centering_val_x, (1 * BLOCK_SIZE + 0.25), starting_z - centering_val_z)
	
	RB_mesh_inst.size = Vector3(BLOCK_SIZE, BLOCK_SIZE + 0.5, BLOCK_SIZE)
	RB_collision.scale = Vector3(0.5, 0.5, 0.5)
	RB_mesh.mesh = RB_mesh_inst
	
	row_inst.add_child(range_block)
	
	
func create_new_ground_block(x: int, y: int, z: int, row_inst: Node3D, length:Vector2, center: bool): 
	var ground_block = block_resource.instantiate()
	var GB_mesh      = ground_block.get_child(0)
	var GB_collision = ground_block.get_child(1)
	var GB_mesh_inst = GB_mesh.mesh.duplicate()
	var GB_material  = StandardMaterial3D.new()
	
	ground_block.height = BLOCK_SIZE
	
	ground_block.colour = Color("a640ff")
	
	GB_material.albedo_color = Color("a640ff") # Purple
	GB_mesh.material_override = GB_material
	
	ground_block.row = x
	ground_block.col = z
	
	var starting_x = x * BLOCK_SIZE - 0.25 + 0.5
	var starting_z = z * BLOCK_SIZE + 0.25 + 0.5

	var centering_val_x = length.y / 2
	var centering_val_z = length.x / 2
	
	ground_block.position = Vector3(starting_x - centering_val_x, 1 * BLOCK_SIZE, starting_z - centering_val_z)
	GB_mesh_inst.size = Vector3(BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)
	GB_collision.scale = Vector3(0.5, 0.5, 0.5)
	GB_mesh.mesh = GB_mesh_inst
	
	row_inst.add_child(ground_block)


func find_center_block():
	var x_mid = len(map) / 2
	var z_mid = len(map[0]) / 2
	
	return Vector2(x_mid, z_mid) 
	
func get_tile_under_mouse() -> Vector3:
	var camera = get_viewport().get_camera_3d()
	if not camera:
		return Vector3()

	# Get mouse position in screen coordinates
	var mouse_pos = get_viewport().get_mouse_position()
	
	# Define the Z-plane where the tiles exist (e.g., assuming Y=0 is the grid level)
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_dir = camera.project_ray_normal(mouse_pos)
	
	# Find intersection with the Y=0 plane (assuming grid is at Y=0)
	var t = -ray_origin.y / ray_dir.y  # Solve for Y=0
	if t < 0:
		return Vector3()  # Mouse is above or below the grid
	
	var world_pos = ray_origin + ray_dir * t  # Get world position on the grid

	# Snap to the nearest tile in grid coordinates
	var tile_x = round(world_pos.x / BLOCK_SIZE) * BLOCK_SIZE
	var tile_z = round(world_pos.z / BLOCK_SIZE) * BLOCK_SIZE

	return Vector3(tile_x, 0, tile_z)
