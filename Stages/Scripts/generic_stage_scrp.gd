extends Node3D

@onready var map_update_controller = $map_update_controller
@onready var child = $Specific_stage_scrp
@onready var map 
@onready var path

var block_resource = preload("res://Map-Building/Blocks/Block.tscn")
var spawner_resource = preload("res://Map-Building/Blocks/spawner.tscn")
var exit_resource = preload("res://Map-Building/Blocks/exit.tscn")

var ranged_block_resource = preload("res://Map-Building/Blocks/ranged_block.tscn")
var ground_block_resource = preload("res://Map-Building/Blocks/ground_block.tscn")

const BLOCK_SIZE := 1

var x_pos_base := BLOCK_SIZE - 0.1 + 0.5
var z_pos_base := BLOCK_SIZE + 0.1 + 0.5

var grid_index = {}
var path_count = 0 
var spawners = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawners = child.spawners
	start_stage(grid_index)


func start_stage(grid_index): 
	await get_tree().process_frame
	var count = 0 
	
	for spawner in child.spawners: 
		var index 
		var size = child.paths.size()
		if count < size:
			index = child.paths[count]
		spawner.recieve_spawn_info(grid_index, child.spawns, index) 
		count += 1
	
	GameStart.start_game()
