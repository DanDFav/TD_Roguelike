extends CharacterBody3D

var path 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("Path: ", path[0].position)
	#print("Currnet: ", position)
	global_position = global_position.move_toward(Vector3(path[0].global_position.x, global_position.y , path[0].global_position.z), delta*0.60)
