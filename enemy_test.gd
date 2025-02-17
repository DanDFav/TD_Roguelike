extends CharacterBody3D

var path 
var path_segment = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#print("Path: ", path[0].position)
	#print("Currnet: ", position)
	global_position = global_position.move_toward(Vector3(path[path_segment].global_position.x, global_position.y , path[path_segment].global_position.z), delta*0.80)
	#print(global_position)
	#print(path[path_segment].global_position)
	if global_position == Vector3(path[path_segment].global_position.x, global_position.y, path[path_segment].global_position.z): 
		path_segment = clamp(path_segment + 1, 0, len(path) -1 )
		

 
