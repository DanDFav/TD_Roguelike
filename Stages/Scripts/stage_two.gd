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
var spawns = [[0, 1.0, 0, -1], [0, 4.2, 0, -1], [2, 6.0, 0, -1], [0, 10.2, 0, -1], [0, 11.2, 0, -1], [0, 17.2, 0, -1], [0, 18.2, 0, -1], [0, 19.2, 0, -1], [1.0, 26.0, 1]]

#var spawns
var spawners = []
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
