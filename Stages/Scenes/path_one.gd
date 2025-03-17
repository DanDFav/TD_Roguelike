extends Node3D


var path_list = []
var finished = false

func append_path(node):
	path_list.append(node)


func _ready() -> void:
	await get_tree().process_frame
	
	for child in get_children(): 
		if child.start: 
			child.distribute_self()


func finished_dist(): 
	finished = true
	distribute_percent()

func distribute_percent(): 
	var count = 0
	var length = len(path_list)
	for i in length:
		var path_node = path_list[i][0] 
		var block = path_list[i][1]
		if count < len(path_list) - 1: 
			block.next_block = path_list[count + 1][0]
		if path_node: 
			path_node.percent_start = float(count) / float(length) 
			path_node.percent_end = float(count + 1) / float(length) 
			count += 1
