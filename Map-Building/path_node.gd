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
var prev_node = []

func _ready() -> void:
	path_parent = get_parent()
	vis_layer = path_parent.vis_layer 
	self_layer = path_parent.self_layer 
	
	if vis_layer == -1 or self_layer == -1: 
		print("WARNING: path parent has no vis_layer or self_layer set")
	
	forward.collision_mask = vis_layer
	area.collision_layer = self_layer
	area.collision_mask = self_layer

func disgusting(node, index, new_path): 
	var block = node.block
	if not block: 
		var block_set =  new_path[index] 	
		node.block = block_set
		block = node.block
	else: 
		for i in node.prev_node:
			if i == null:
				break
			elif i != null: 
				node.prev_node.erase(i)
				node.next_node = null
			elif i.block.roadblocked: 
				node.prev_node.erase(i)
				i.block.clear_nodes([node.path_parent.name])
				node.next_node = null
	
	var path_name = node.path_parent.name
	block.path_node[path_name] = node
	if index <= len(new_path) - 1: 
		block.next_block[path_name] = new_path[index + 1]
	
	if index > 0: 
		var previous = node.prev_node
		var prev_to_set_block = new_path[index - 1]
		var p_name = node.path_parent.name
		var prev_to_set_node = prev_to_set_block.path_node[p_name]
		previous.append(prev_to_set_node)
		node.prev_node = node.prev_node.filter(func(item): return item != null)
		for i in node.prev_node: 
			i.next_node = node
			i.block.next_node[path_name] = node

func distribute_self(prev):
	prev_node.append(prev) 
	block = down.get_collider()
	block.path_node[path_parent.name] = self
	
	if not end: 
		next_node = forward.get_collider().get_parent()
		block.next_node[path_parent.name] = next_node
	
	if not start: 
		for i in len(prev_node):
			prev_node[i].block.next_block[path_parent.name] = block
	
	path_parent.append_path([self, block])
	
	if start and block is Block: 
		print("WARNING: START NODE OF PATH IS NOT A SPAWNER")
	
	if not end: 
		next_node.distribute_self(self)
	elif end: 
		path_parent.finished_dist()

func build_new_path(new_path, index, path, time):
	if index == len(new_path) - 1: 
		#var end = Time.get_ticks_usec()
		#print("Execution time: ", (end - time) / 1000.0, " ms")
		path_parent.get_end()
		#var end_2 = Time.get_ticks_usec()
		#print("Execution time: ", (end_2 - time) / 1000.0, " ms")
		return
	
	var node_location = new_path[index]
	var next_node_location = new_path[index + 1]
	
	var vis = vis_layer
	var node 
	if len(node_location.path_node) == 0:
		node = create_new_node(node_location, path)
	elif not node_location.path_node.has(path): 
		node = create_new_node(node_location, path)
	else: 
		node = node_location.path_node[path]
	
	var direction = get_relative_direction(node_location, next_node_location)
	rotate_node(node, direction)
	
	disgusting(node, index, new_path)
	
	build_new_path(new_path, index + 1, path, time)


func create_new_node(block, path): 
	var new_path_node = path_node_resource.instantiate()
	self.get_parent().add_child(new_path_node)
	new_path_node.global_position = block.global_position
	new_path_node.global_position.y += 1.0
	new_path_node.vis_layer = vis_layer
	new_path_node.self_layer = self_layer
	new_path_node.path_parent = get_parent()
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
