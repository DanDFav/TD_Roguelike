extends Node3D
class_name Roadblock

@onready var root = get_tree().root.get_node("Stage")
@onready var unit_controller = root.get_node("Unit_controller")
@onready var map_controller = root.get_node("map_update_controller")
@onready var stats = $stats_n3D


var blocking = []

var placed_on

func placed_func(block): 
	placed_on = block  
	block.roadblocked = true
	block.roadblock_instance = self
	position.y = block.height 
	global_position.x = block.global_position.x 
	global_position.z = block.global_position.z 
	unit_controller.placed(stats.unit_name)
	notify_map()

func notify_map(): 
	map_controller.map_updated()

func add_blocker(enemy):
	blocking.append(enemy)


func destroy(): 
	placed_on.roadblocked = false
	placed_on.roadblock_instance = null
	placed_on.occupied = false
	placed_on.unit_on_tile = null
	notify_map()
	for enemy in blocking: 
		enemy.unroadblock()
	
	get_parent().queue_free()
