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
			child.distribute_self()


func finished_dist(): 
	distribute_percent()


## TODO: Rewrite this section to just handle distributing percents, i think we can handle the other stuff elsewhere 
func distribute_percent(): 
	var count = 0
	var length = len(path_list)
	var xyz = self.name
	for i in length:
		var path_node = path_list[i][0] 
		var block = path_list[i][1]
		
		if count < len(path_list) - 1: 
			#add_path_entry(path, next_block): 
			block.add_path_entry(self.name, path_list[count+1][1], path_list, count, path_node)
			#block.next_block = path_list[count + 1][1]
		if path_node: 
			path_node.percent_start = float(count) / float(length) 
			path_node.percent_end = float(count + 1) / float(length) 
			path_node.path_position = count
			count += 1
