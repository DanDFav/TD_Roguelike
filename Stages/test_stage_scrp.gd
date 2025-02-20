extends Node3D

var map := [
			 [1, 1, 1, 1, 1, 1, 1, 1, 1],
			 [1, 1, 0, 0, 0, 0, 0, 0, 1],
			 [1, 0, 0, 1, 1, 1, 1, 0, 1],
			 [1, 0, 1, 1, 1, 1, 1, 0, 1],
			 [1, 0, 1, 0, 0, 0, 0, 0, 1],
			 [1, 2, 1, 3, 1, 1, 1, 1, 1],
			 [1, 1, 1, 1, 1, 1, 1, 1, 1]
		   ]

#var spawns = [[0, 0.2, 0], [0, 0.6, 0], [0, 1.0, 0], [0, 1.4, 0],[0,1.8, 0]]

#[0] = enemy_type
#[1] = time 
#[2] = path 
#var spawns = [[0, 0.2, 0], [0, 1.2, 0], [0, 2.2, 0], [0, 3.2, 0], [0, 5.2, 0], [0, 6.0, 0], [1.0, 6.6, 0]]
#var spawns = [[0, 0.2, 0], [0, 4.2, 0], [0, 5.2, 0], [0, 6.2, 0], [0, 7.2, 0], [0, 12.2, 0], [0, 16.2, 0]]
#var spawns = [[1, 0.2, 0], [0, 3, 0]]
var spawns = [[0, 0.2, 0], [1, 1.0, 0], [0, 30, 0], [0, 31, 0], [0, 32, 0]]


var path_one = [Vector2(1, 4), Vector2(1,3), Vector2(1,2), Vector2(2,2), Vector2(2,1),  Vector2(3,1),  Vector2(4,1), Vector2(5,1), Vector2(6,1), Vector2(7,1)
			,   Vector2(7,2),  Vector2(7,3), Vector2(7,4), Vector2(6,4), Vector2(5,4), Vector2(4,4), Vector2(3,4), Vector2(3,5)]
			
var object_inst 

func recieve_signal_from_spawner(object):
	object_inst = object

func start_stage(grid_index): 
	object_inst.recieve_spawn_info(grid_index, spawns, path_one) 
	pass
