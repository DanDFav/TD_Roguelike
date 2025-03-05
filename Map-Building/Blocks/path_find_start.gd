extends Node3D


@onready var ray_casts = $"../ray_casts"

func self_find_path(): 
	ray_casts.get_neighbours()
