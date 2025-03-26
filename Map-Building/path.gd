extends Node3D


@export var vis_layer  = -1
@export var self_layer = -1

var path_list = []

func append_path(node):
	path_list.append(node)


func _ready() -> void:
	await get_tree().process_frame
	
	for child in get_children(): 
		if child.start: 
			child.distribute_self(null)
			break


func finished_dist(): 
	get_end()


func get_end():
	for node in get_children(): 
		if node.end: 
			var count = 0 
			backtrack_from_end(node, count)

func backtrack_from_end(node, count, visited = {}):
	if node == null or node in visited: 
		return  

	visited[node] = true  
	node.path_position = count
	node.block.path_position[self.name] = count

	for n in node.prev_node:
		backtrack_from_end(n, count + 1, visited)
