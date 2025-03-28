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
var spawns = []

#var spawns
@onready var spawners = [$blocks/Spawner]
var starting_morale = 15
var paths = [[]]

var roadblocks = 0

func _ready() -> void:
	add_utilities()


func add_utilities():
	for i in range(roadblocks): 
		Party.add_to_party("Roadblock")
