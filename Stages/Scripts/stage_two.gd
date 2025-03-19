extends Node3D


var map := [
			 [1,1,1,1,1,1,1,1,1],
			 [1,2,0,0,0,0,0,3,1],
			 [1,0,0,0,0,0,0,0,1],
			 [1,1,1,1,1,1,1,1,1],
		   ]

#[0] = enemy_type
#[1] = time 
#[2] = path 
var spawns = [[0, 1.0, 0, 1], [0, 3.0, 1, 2], [0, 5.0, 0, 1], [0, 7.0, 1, 2], [2, 14.0, 0, 1], [0, 16.0, 1, 2], [0, 16.0, 0, 1], [0, 17.0, 1, 2], [0, 17.0, 0, 1]]

#var spawns
@onready var spawners = [$blocks/Spawner, $blocks/Spawner2]
var starting_morale = 15
var paths = [[]]

var roadblocks = 4

func _ready() -> void:
	add_utilities()


func recieve_signal_from_spawner(spawner):
	spawners.append(spawner)
	

func start_stage(grid_index): 
	var count = 0 
	for spawner in spawners: 
		spawner.recieve_spawn_info(grid_index, spawns, paths[count]) 
		count += 1

func add_utilities():
	for i in range(roadblocks): 
		Party.add_to_party("Roadblock")
