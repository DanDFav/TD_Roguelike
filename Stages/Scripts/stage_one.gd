extends Node3D


var map := [
			 [-1,-1,-1,-1, 1, 1, 1, 1, 1],
			 [-1,-1,-1,-1, 1, 2, 1, 2, 1],
			 [ 1, 1, 1, 1, 1, 0, 1, 0, 1],
			 [ 1, 0, 0, 3, 1, 0, 1, 0, 1],
			 [ 1, 0, 1, 1, 1, 0, 1, 0, 1],
			 [ 1, 0, 0, 0, 0, 0, 0, 0, 1],
			 [ 1, 1, 1, 1, 1, 1, 1, 1, 1]
		   ]

#[0] = enemy_type
#[1] = time 
#[2] = path 
var spawns = [[0, 1.0, 0, -1], [0, 3.0, 1, -1], [0, 5.0, 0, -1], [0, 7.0, 1, -1], [2, 14.0, 0, -1], [0, 16.0, 1, -1], [0, 16.0, 0, -1], [0, 17.0, 1, -1], [0, 17.0, 0, -1]]
#var spawns
var spawners = []
var starting_morale = 15
var paths = [[Vector2(5,2), Vector2(5,3), Vector2(5,4), Vector2(5,5), Vector2(4,5), Vector2(3,5), Vector2(2,5), Vector2(1,5), Vector2(1,4), Vector2(1,3), Vector2(2,3), Vector2(3,3),],  
			 [Vector2(7,2), Vector2(7,3), Vector2(7,4), Vector2(7,5), Vector2(6,5), Vector2(5,5), Vector2(4,5), Vector2(3,5), Vector2(2,5), Vector2(1,5), Vector2(1,4), Vector2(1,3), Vector2(2,3), Vector2(3,3), ]]



func recieve_signal_from_spawner(spawner):
	spawners.append(spawner)

func start_stage(grid_index): 
	var count = 0 
	for spawner in spawners: 
		spawner.recieve_spawn_info(grid_index, spawns, paths[count]) 
		count += 1
