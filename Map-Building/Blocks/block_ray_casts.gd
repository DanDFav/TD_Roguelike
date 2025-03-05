extends Node3D
class_name path_find_ray_cast

@onready var parent_block = get_parent()

@onready var up    = $Up
@onready var down  = $Down
@onready var left  = $Left
@onready var right = $Right


var position_vec 


func _ready() -> void:
	await get_tree().process_frame
	position_vec = Vector2(parent_block.row, parent_block.col)


func get_neighbours(): 
	var up_collider = up.get_collider()
	if up_collider.is_in_group("ground_block"): 
		print("FOUND")
