extends Node3D

@export var start = false
@export var end = false 
var vis_layer 
var self_layer

@onready var down = $down
@onready var forward = $forward
@onready var area = $path_node_collision


var next_node = null
var block 

var path_parent
var percent_start
var percent_end 

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
	
	if not end: 
		next_node.distribute_self()
	elif end: 
		path_parent.finished_dist()
