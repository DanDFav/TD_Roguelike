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

#func find_path_to_spawner():
	#var queue = []
	#var visited = {}
	#var came_from = {}
#
	## Start from this block
	#queue.append(parent_block)
	#visited[parent_block] = true
	#came_from[parent_block] = null
#
	#while queue.size() > 0:
		#var current = queue.pop_front()
		#
		## If we found the exit, reconstruct and store the path
		#print(current.is_exit)
		#if current.is_exit:
			#set_path_references(came_from, current)
			#full_path = reconstruct_path(came_from, current)
			#return true
#
		## Get neighbors
		#var neighbors = get_neighbors(current)
		#
		#
		#for neighbor in neighbors:
			#if neighbor not in visited:
				#queue.append(neighbor)
				#visited[neighbor] = true
				#came_from[neighbor] = current
	#return false  
#
#func reconstruct_path(came_from, end_block):
	#var path = []
	#var current = end_block
	#
	#while current != null:
		#path.append(current)
		#current = came_from.get(current, null)
	#
	##  # Reverse to get path from start to end
	#return path
#
#
#func propegate_full_path(): 
	#pass
#
## Helper function to get valid neighbors
#func get_neighbors(block):
	#var neighbors = []
	#var ray_casts = block.get_node("ray_casts")
	#var up_collider    = ray_casts.up.get_collider()
	#var down_collider  = ray_casts.down.get_collider()
	#var left_collider  = ray_casts.left.get_collider()
	#var right_collider = ray_casts.right.get_collider()
#
	#for collider in [up_collider, down_collider, left_collider, right_collider]:
		#if collider and collider.is_in_group("ground_block") and not collider.roadblocked:
			#neighbors.append(collider)
#
	#return neighbors
#
## **Set the path references**
#func set_path_references(came_from, end_block):
	#var current = end_block
	#while current != null:
		#var previous = came_from.get(current, null)
		#if previous:  # Set reference to the next block in the shortest path
			#previous.exit = current
		##change_mat(current, Color(0, 1, 0))  # Green for the optimal path
		#current = previous
#
#func change_mat(node, colour): 
	#var material = StandardMaterial3D.new()
	#material.albedo_color = colour
	#
	#var mesh = node.get_node("MeshInstance3D")
	#if mesh: 
		#mesh.set_surface_override_material(0, material)
