extends Node3D

#[0] = enemy_type
#[1] = time 
#[2] = path 
var spawns = [[0, 1.0, 0, 1], [0, 6.0, 0, 1]]

@onready var spawners = [$blocks/Spawner]
var starting_morale = 15
var paths = [[]]

var roadblocks = 3

func _ready() -> void:
	add_utilities()


func add_utilities():
	for i in range(roadblocks): 
		Party.add_to_party("Roadblock")
