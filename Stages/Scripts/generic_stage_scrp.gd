extends Node3D

@onready var map_update_controller = $map_update_controller
@onready var child = $Specific_stage_scrp
@onready var map 
@onready var path

var block_resource = preload("res://Map-Building/Blocks/Block.tscn")
var spawner_resource = preload("res://Map-Building/Blocks/spawner.tscn")
var exit_resource = preload("res://Map-Building/Blocks/exit.tscn")

var ranged_block_resource = preload("res://Map-Building/Blocks/ranged_block.tscn")
var ground_block_resource = preload("res://Map-Building/Blocks/ground_block.tscn")

const BLOCK_SIZE := 1

var x_pos_base := BLOCK_SIZE - 0.1 + 0.5
var z_pos_base := BLOCK_SIZE + 0.1 + 0.5

var grid_index = {}
var path_count = 0 
var spawners = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawners = child.spawners
	start_stage(grid_index)


func start_stage(grid_index): 
	await get_tree().process_frame
	var count = 0 
	
	for spawner in child.spawners: 
		var index 
		var size = child.paths.size()
		if count < size:
			index = child.paths[count]
		spawner.recieve_spawn_info(grid_index, child.spawns, index) 
		count += 1
	
	GameStart.start_game()

func create_map(): 
	var center_block = find_center_block()
	for x in range(len(map)):
		var new_row = Node3D.new()
		add_child(new_row)
		for z in range(len(map[x])):
			var block_type = map[x][z]
			if block_type == 1: 
				create_new_range_block(z, block_type, x, new_row, center_block)
			elif block_type == 0: 
				create_new_ground_block(z, block_type, x, new_row, center_block)
			elif block_type == 2: 
				create_new_special(z, block_type, x, center_block)
			elif block_type == 3: 
				create_new_special(z, block_type, x, center_block)
	


func find_center_block():
	var x_mid = len(map) / 2
	var z_mid = len(map[0]) / 2
	
	return Vector2(x_mid, z_mid) 

func create_new_special(x: int, y: int, z:int, length: Vector2): 
	var special
	if y == 2: 
		special = spawner_resource.instantiate()
		special.path_number = path_count
		spawners.append(special)
		path_count += 1 
	elif y == 3: 
		special = exit_resource.instantiate()
		grid_index[x*10 + z] = special
		special.is_exit = true
	
	special.row = x
	special.col = z
	
	var centering_val_x = length.y / 2
	var centering_val_z = length.x / 2
	
	special.position = Vector3(x - centering_val_x, 0, z - centering_val_z)
	
	add_child(special)
	map_update_controller.subscribe(special)


func create_new_range_block(x: int, y: int, z: int, row_inst: Node3D, length:Vector2): 
	var range_block = ranged_block_resource.instantiate()
	var centering_val_x = length.y / 2
	var centering_val_z = length.x / 2
	
	var x_pos = x * BLOCK_SIZE - centering_val_x
	var z_pos = z * BLOCK_SIZE - centering_val_z
	
	
	range_block.row = x
	range_block.col = z
	
	range_block.position = Vector3(x_pos, 0, z_pos)
	
	grid_index[x*10 + z] = range_block
	
	row_inst.add_child(range_block)
	map_update_controller.subscribe(range_block)
	
	
func create_new_ground_block(x: int, y: int, z: int, row_inst: Node3D, length:Vector2): 
	var ground_block = ground_block_resource.instantiate()
	var centering_val_x = length.y / 2
	var centering_val_z = length.x / 2
	
	ground_block.row = x
	ground_block.col = z
	
	var x_pos = x * BLOCK_SIZE - centering_val_x
	var z_pos = z * BLOCK_SIZE - centering_val_z
	
	ground_block.position = Vector3(x_pos, 0, z_pos)
	
	grid_index[x*10 + z] = ground_block
	
	row_inst.add_child(ground_block)
	map_update_controller.subscribe(ground_block)
