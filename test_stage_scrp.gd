extends Node3D

var map := [
			 [1, 1, 1, 1, 1, 1, 1, 1],
			 [1, 0, 0, 0, 0, 0, 0, 1],
			 [1, 0, 1, 1, 1, 1, 0, 1],
			 [1, 0, 1, 1, 1, 1, 0, 1],
			 [1, 0, 1, 1, 1, 1, 0, 1],
			 [1, 0, 1, 0, 0, 0, 0, 1],
			 [1, 2, 1, 3, 1, 1, 1, 1],
			 [1, 1, 1, 1, 1, 1, 1, 1]
		   ]

#var spawns = [[0, 0.2, 0], [0, 0.6, 0], [0, 1.0, 0], [0, 1.4, 0],[0,1.8, 0]]
var spawns = [[0, 0.2, 0]]

var path_one = [Vector2(1,1), Vector2(1, 6), Vector2(5, 6), Vector2(5, 3), Vector2(6, 3)]
var path_nodes 
var object_inst 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func recieve_signal_from_spawner(object):
	object_inst = object
	object_inst.recieve_spawn_info(spawns) 
