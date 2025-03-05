extends Node3D


var map := [
			 [1,1,1,1,1],
			 [1,3,0,2,1],
			 [1,1,1,1,1],
			 
		   ]

#[0] = enemy_type
#[1] = time 
#[2] = path 
var spawns = []
#var spawns
var spawners = []
var starting_morale = 15
var paths = [[]]


func recieve_signal_from_spawner(spawner):
	spawners.append(spawner)

func start_stage(grid_index): 
	var count = 0 
	for spawner in spawners: 
		spawner.recieve_spawn_info(grid_index, spawns, paths[count]) 
		count += 1
