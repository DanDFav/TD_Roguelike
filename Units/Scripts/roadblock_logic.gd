extends Node3D
class_name Roadblock

@onready var root = get_tree().root.get_node("Stage")
@onready var unit_controller = root.get_node("Unit_controller")
@onready var map_controller = root.get_node("map_update_controller")
@onready var stats = $stats_n3D

var placed_on

func placed_func(block): 
	placed_on = block  
	block.roadblocked = true
	position.y = block.height 
	global_position.x = block.global_position.x 
	global_position.z = block.global_position.z 
	unit_controller.placed(stats.unit_name)
	notify_map()

func notify_map(): 
	map_controller.map_updated()
