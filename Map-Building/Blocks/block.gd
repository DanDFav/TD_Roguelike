extends Node3D
class_name Block

@export var row: int
@export var col: int 

@export var colour: Color
@export var height: float

@onready var mesh = $MeshInstance3D
@onready var ray_casts = $ray_casts

var occupied = false 
var unit_on_tile 

var explored = false 
var roadblocked = false 
var roadblock_instance
@export var is_exit = false 



var t_global_pos
var edge_dict = {}

var mouse_inside = false

var enemies_on_tile = []

var path_position = {}
var path_node = {}
var next_node = {}
var next_block = {}


@onready var root = get_tree().root.get_node("Stage")
@onready var unit_controller = root.get_node("Unit_controller")

func _ready() -> void:
	block_positions()

func _process(delta: float) -> void:
	if mouse_inside: 
		var on_hover_mat = StandardMaterial3D.new()
		on_hover_mat.albedo_color = Color("e8af7e")
		mesh.material_override = on_hover_mat
		var unit = unit_controller.selected_unit
		if unit:
			var unit_place_comp = unit.get_node("placement_component_n3D")
			if not unit_place_comp.can_place(self):
				on_hover_mat.albedo_color = Color("e85869")
			else: 
				on_hover_mat.albedo_color = Color("58e894")

func add_enemy_on_tile(enemy : enemy_movement):
	enemies_on_tile.append(enemy)

func remove_enemy_on_tile(enemy : enemy_movement):
	enemies_on_tile.erase(enemy)

func place_unit(unit): 
	if not occupied and unit != null: 
		var unit_place_comp = unit.get_node("placement_component_n3D")
		if unit_place_comp.can_place(self):
			occupied = true 
			unit_on_tile = unit
			unit_place_comp.place_unit(self)
	else: 
		print("This tile is occupied")


func unit_dead(unit: Unit): 
	occupied = false 
	unit_on_tile = null


func destroy_roadblock(): 
	p_change_road_destroy()
	roadblocked = false 
	roadblock_instance = null
	

func roadblock(roadblock_self): 
	roadblocked = true
	roadblock_instance = roadblock_self
	path_changed()

func clear_nodes(node_keys): 
	for i in node_keys: 
		if path_node.has(i):
			path_node[i].queue_free()
	for i in node_keys: 
		path_position.erase(i)
		path_node.erase(i)
		next_node.erase(i)
		next_block.erase(i)


func p_change_road_destroy(): 
	var nodes = ray_casts.get_surrounding_path_blocks()
	var paths_on_this_block = nodes.keys()
	var blocks_to_run = {}
	
	for path in paths_on_this_block: 
		var earliest_block = nodes[path]
		var rays = earliest_block.get_node('ray_casts')
		var path_to_build = rays.find_closest_path_to_exit()
		if path_to_build:
			var start = Time.get_ticks_usec()
			var path_node_x = path_to_build[0].path_node[path]
			path_node_x.build_new_path(path_to_build, 0, path, start)

func path_changed(): 
	var paths_on_this_block = path_node.keys()
	
	var blocks_to_run = {}
	for path in paths_on_this_block: 
		blocks_to_run[path] = await roadblock_instance.get_surrounding_blocks(path)
		if blocks_to_run[path] != null: 
			var path_to_build = blocks_to_run[path].get_node('ray_casts').find_closest_path_to_exit()
			if path_to_build:
				var start = Time.get_ticks_usec()
				var path_node_x = path_to_build[0].path_node[path]
				path_node_x.build_new_path(path_to_build, 0, path, start)
	clear_nodes(paths_on_this_block)


func _on_area_3d_mouse_entered() -> void:
	if not occupied: 
		mouse_inside = true

func _on_area_3d_mouse_exited() -> void:
	mouse_inside = false
	var normal_mat = StandardMaterial3D.new()
	normal_mat.albedo_color = colour
	mesh.material_override = normal_mat


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var unit = unit_controller.selected_unit
			if unit: 
				var unit_place_comp = unit.get_node("placement_component_n3D")
				if event.pressed and unit_place_comp.can_place(self):
					place_unit(unit)


func path_find(): 
	ray_casts.get_neighbours()

func block_positions(): 
	t_global_pos = global_position
	edge_dict["north"] = Vector3(t_global_pos.x, t_global_pos.y + 0.5, t_global_pos.z - 0.5)
	edge_dict["south"] = Vector3(t_global_pos.x, t_global_pos.y + 0.5, t_global_pos.z + 0.5)
	edge_dict["east"] =  Vector3(t_global_pos.x + 0.5, t_global_pos.y + 0.5, t_global_pos.z) 
	edge_dict["west"] = Vector3(t_global_pos.x - 0.5, t_global_pos.y + 0.5, t_global_pos.z)
