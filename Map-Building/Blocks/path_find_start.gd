extends Node3D


@onready var ray_casts = $"../ray_casts"


func _ready() -> void:
	GameStart.subscribe(self)
	print("Subbed")

func self_find_path(): 
	ray_casts.get_neighbours()
	
func notify_game_start(): 
	print("CALLED")
	self_find_path()
	GameStart.path_found()
