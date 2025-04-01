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
var spawns = [[2, 1.0, 0, 1], [1, 3.0, 1, 2], [0, 5.0, 0, 1], [2, 7.0, 1, 2], [0, 14.0, 0, 1], [0, 16.0, 1, 2], [0, 16.0, 0, 1], [0, 17.0, 1, 2], [0, 17.0, 0, 1]]

#var spawns
@onready var spawners = [$blocks/Spawner, $blocks/Spawner2]
var starting_morale = 15
var paths = [[]]

var roadblocks = 4

func _ready() -> void:
	add_utilities()


func add_utilities():
	for i in range(roadblocks): 
		Party.add_to_party("Roadblock")
