extends Node3D
class_name Roadblock

@onready var root = get_tree().root.get_node("Stage")
@onready var unit_controller = root.get_node("Unit_controller")
@onready var map_controller = root.get_node("map_update_controller")
@onready var stats = $stats_n3D


#@onready var top_left = $neighbours/top_left
#@onready var top_middle = $neighbours/top_middle
#@onready var top_right = $neighbours/top_right
#@onready var middle_left = $neighbours/middle_left
#@onready var middle_right = $neighbours/middle_right
#@onready var bottom_left = $neighbours/bottom_left
#@onready var bottom_middle = $neighbours/bottom_middle
#@onready var bottom_right = $neighbours/bottom_right

@onready var colliders = [$neighbours/top_left, $neighbours/top_middle, $neighbours/top_right, $neighbours/middle_left, $neighbours/middle_right, $neighbours/bottom_left, $neighbours/bottom_middle, $neighbours/bottom_right]

var blocking = []

var placed_on

func placed_func(block : Block): 
	placed_on = block  
	block.roadblock(self) 
	position.y = block.height 
	global_position.x = block.global_position.x 
	global_position.z = block.global_position.z 
	unit_controller.placed(stats.unit_name)
	#notify_map()
#
#func notify_map(): 
	#map_controller.map_updated()

func get_surrounding_blocks(path): 
	await get_tree().process_frame
	var surrounding = {}
	for collider in colliders: 
		var coll_name = collider.name
		var coll_obj = collider.get_collider()
		if coll_obj: 
			surrounding[coll_name] = coll_obj
	print(surrounding)
	var positions = surrounding.values()
	var lowest 
	var selected 
	for block in positions: 
		if len(block.path_position) > 0: 
			var path_pos = block.path_position[path]
			if lowest == null: 
				lowest = path_pos
				selected = block
			else: 
				if lowest > path_pos:
					lowest = path_pos
					selected = block
	return selected 

func add_blocker(enemy):
	blocking.append(enemy)


func destroy(): 
	placed_on.roadblocked = false
	placed_on.roadblock_instance = null
	placed_on.occupied = false
	placed_on.unit_on_tile = null
	#notify_map()
	for enemy in blocking: 
		enemy.unroadblock()
	
	get_parent().queue_free()


func cant_place() -> void:
	var on_hover_mat = StandardMaterial3D.new()
	on_hover_mat.albedo_color = Color(0.8,0,0)
	$MeshInstance3D.material_override = on_hover_mat


func can_place() -> void:
	var normal_mat = StandardMaterial3D.new()
	normal_mat.albedo_color = Color("3b3838")
	$MeshInstance3D.material_override = normal_mat
