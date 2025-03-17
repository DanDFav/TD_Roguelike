extends Node3D


@onready var ray_casts = $"../ray_casts"


func _ready() -> void:
	GameStart.subscribe(self)
	print("Subbed")

func self_find_path(): 
	#var path_found = ray_casts.find_path_to_spawner()
	ray_casts.build_map()
	#return path_found
	
func notify_game_start(): 
	print("CALLED")
	self_find_path()
	GameStart.path_found()


func map_updated(): 
	return self_find_path()
