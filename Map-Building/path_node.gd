extends Node3D

@export var start = false
@export var end = false 

@onready var down = $down
@onready var forward = $forward

var next_node = null
var block 

var path_parent
var percent_start
var percent_end 

func distribute_self(): 
	if not end: 
		next_node = forward.get_collider().get_parent()
	
	block = down.get_collider()
	
	path_parent = get_parent()
	path_parent.append_path([self, block])
	
	if not end: 
		next_node.distribute_self()
	elif end: 
		path_parent.finished_dist()
