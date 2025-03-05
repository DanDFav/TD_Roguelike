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
	var up_collider    = up.get_collider()
	var down_collider  = down.get_collider()
	var left_collider  = left.get_collider()
	var right_collider = right.get_collider() 
	
	parent_block.explored = true 

	
	#change_mat(parent_block, Color(0, 1, 0))
	
	
	if up_collider: 
		if up_collider.is_in_group("ground_block") and up_collider != parent_block and up_collider.explored == false: 
					#change_mat(up_collider,  Color(1, 0, 0))
					var test = get_parent()
					up_collider.exit = get_parent()
					if up_collider is Spawner: 
						return 
					up_collider.path_find()
	
	if down_collider: 
		if down_collider.is_in_group("ground_block") and down_collider != parent_block and down_collider.explored == false: 
			#change_mat(down_collider,  Color(1, 0, 0))
			down_collider.exit = get_parent()
			if down_collider is Spawner: 
				return 
			down_collider.path_find()
	
	if left_collider: 
		if left_collider.is_in_group("ground_block") and left_collider != parent_block and left_collider.explored == false: 
			#change_mat(left_collider,  Color(1, 0, 0))
			left_collider.exit = get_parent()
			if left_collider is Spawner: 
				return 
			left_collider.path_find()

	if right_collider: 
		if right_collider.is_in_group("ground_block") and right_collider != parent_block and right_collider.explored == false: 
			#change_mat(right_collider,  Color(1, 0, 0))
			right_collider.exit = get_parent()
			if right_collider is Spawner: 
				return 
			right_collider.path_find()
	
	return 


func change_mat(node, colour): 
	var material = StandardMaterial3D.new()
	material.albedo_color = colour
	
	var mesh = node.get_node("MeshInstance3D")
	if mesh: 
		mesh.set_surface_override_material(0, material)
