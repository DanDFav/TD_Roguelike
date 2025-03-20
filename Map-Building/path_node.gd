extends Node3D

@export var start = false
@export var end = false 
var vis_layer 
var self_layer

@onready var down = $down
@onready var forward = $forward
@onready var area = $path_node_collision
@onready var path_node_resource = preload("res://Map-Building/path_node.tscn")


var next_node = null
var block 

var path_parent
var percent_start
var percent_end 
var path_position 

func _ready() -> void:
	path_parent = get_parent()
	vis_layer = path_parent.vis_layer 
	self_layer = path_parent.self_layer 
	
	if vis_layer == -1 or self_layer == -1: 
		print("path parent has no vis_layer or self_layer set")
	
	forward.collision_mask = vis_layer
	area.collision_layer = self_layer
	area.collision_mask = self_layer

func distribute_self(): 
	if not end: 
		next_node = forward.get_collider().get_parent()
	
	block = down.get_collider()
	path_parent.append_path([self, block])
	
	if start and block is Block: 
		print("WARNING: START NODE OF PATH IS NOT A SPAWNER")
	
	if not end: 
		next_node.distribute_self()
	elif end: 
		path_parent.finished_dist()

func build_new_path(new_path, path):
	var first_block = new_path[0]
	var vis = vis_layer
	var count = 1
	for i in len(new_path): 
		if i + 1 < len(new_path):
			var next_block = new_path[i + 1]
			var direction = get_relative_direction(first_block, next_block)
			rotate_node(first_block.path_node[path], direction)
			first_block.path_next_block[path] = next_block
			first_block = next_block 
			create_new_node(next_block, path)
		
	#distribute_self()

func create_new_node(block, path): 
	var new_path_node = path_node_resource.instantiate()
	self.get_parent().add_child(new_path_node)
	new_path_node.global_position = block.global_position
	new_path_node.global_position.y += 1.0
	new_path_node.vis_layer = vis_layer
	new_path_node.self_layer = self_layer
	block.path_node[path] = new_path_node
	return new_path_node

func rotate_node(node, direction: String) -> void:
	match direction.to_lower():
		"west":
			node.rotation_degrees.y = 180  # Facing negative Z
		"east":
			node.rotation_degrees.y = 0    # Facing positive Z
		"south":
			node.rotation_degrees.y = -90  # Facing positive X
		"north":
			node.rotation_degrees.y = 90   # Facing negative X
		_:
			print("Invalid direction:", direction)

func get_relative_direction(first_block: Node3D, next_block: Node3D) -> String:
	var dx = next_block.global_position.x - first_block.global_position.x
	var dz = next_block.global_position.z - first_block.global_position.z  
	
	var grid_size = 1.0
	
	if dx == grid_size and dz == 0:
		return "east"
	elif dx == -grid_size and dz == 0:
		return "west"
	elif dx == 0 and dz == grid_size:
		return "south"
	elif dx == 0 and dz == -grid_size:
		return "north"
	else:
		return "not adjacent"
