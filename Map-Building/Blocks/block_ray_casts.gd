extends Node3D
class_name path_find_ray_cast

@onready var parent_block = get_parent()

@onready var up    = $Up
@onready var down  = $Down
@onready var left  = $Left
@onready var right = $Right

var position_vec
var full_path
var map = {}
var unique_blocks = []

func _ready() -> void:
	await get_tree().process_frame
	position_vec = Vector2(parent_block.row, parent_block.col)


func build_map():
	if len(map) == 0: 
		get_neighbors(self.get_parent())
		unique_blocks.append(self.get_parent())
		
	while not_completed(): 
		for block in unique_blocks: 
			if block.explored == false: 
				get_neighbors(block)
	
	for block in unique_blocks: 
		block.get_node("ray_casts").map = map

func get_neighbors(block):
	var neighbors = []
	var ray_casts = block.get_node("ray_casts")
	var up_collider = ray_casts.up.get_collider()
	var down_collider = ray_casts.down.get_collider()
	var left_collider = ray_casts.left.get_collider()
	var right_collider = ray_casts.right.get_collider()

	for collider in [up_collider, down_collider, left_collider, right_collider]:
		if collider and collider.is_in_group("ground_block") and not collider.roadblocked:
			neighbors.append(collider)
			if collider not in unique_blocks: 
				unique_blocks.append(collider)
	
	block.explored = true
	map[block] = neighbors
	
	return neighbors


func not_completed(): 
	for block in unique_blocks:  
		if block.explored == false: 
			return true
	
	return false 


func find_closest_path_to_exit(): 
	var queue = []
	var visited = {}
	var came_from = {}
	
	queue.append(self)
	visited[self] = true
	came_from[self] = null
	
	while len(queue) != 0: 
		var current = queue.pop_front()
		var block = current.get_parent()
		if block.is_exit == true: 
			return reconstruct_path(came_from, current) 
		
		for neighbour in map[block]: 
			var neighbour_ray = neighbour.get_node("ray_casts")
			if neighbour_ray not in visited and neighbour.roadblocked == false: 
				queue.append(neighbour_ray)
				visited[neighbour_ray] = true
				came_from[neighbour_ray] = current
	
	print("no path found")
	return null

func get_surrounding_path_blocks():
	var neighbors = []
	var ray_casts = get_node("ray_casts")
	var up_collider = up.get_collider()
	var down_collider = down.get_collider()
	var left_collider = left.get_collider()
	var right_collider = right.get_collider()

	for collider in [up_collider, down_collider, left_collider, right_collider]:
		if collider and collider.is_in_group("ground_block") and not collider.roadblocked:
			neighbors.append(collider)
	
	
	var highest = {}
	var selected = {}
	
	for block in neighbors: 
		var paths_on_block = block.path_node.keys()
		for path in paths_on_block: 
			if not highest.has(path) or highest[path] == null:
				highest[path] = block.path_position[path]
				selected[path] = block
			elif highest[path] <= block.path_position[path]:
				highest[path] = block.path_position[path]
				selected[path] = block
	return selected
	
		#if len(block.path_position) > 0: 
			#var path_pos = block.path_position[path]
			#if highest == null: 
				#highest = path_pos
				#selected = block
			#else: 
				#if highest < path_pos:
					#highest = path_pos
					#selected = block
	#return selected 
	#for i in neighbors: 
		#pass

func reconstruct_path(came_from, exit): 
	var path = []
	var current = exit
	while current != null: 
		path.append(current.get_parent())
		current = came_from[current]
	path.reverse()
	return path
