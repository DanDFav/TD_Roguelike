extends Node3D



var row: int
var col: int 
@export var colour: Color
@export var height: float

@onready var mesh = $MeshInstance3D
@onready var ray_casts = $ray_casts

var occupied = false 
var unit_on_tile 

var explored = false 
var roadblocked = false 
var exit 

var is_this_exit = false

@onready var root = get_tree().root.get_node("Stage")
@onready var unit_controller = root.get_node("Unit_controller")

func place_unit(): 
	var unit = unit_controller.selected_unit
	
	if not occupied and unit != null: 
		var unit_place_comp = unit.get_node("placement_component_n3D")
		if unit_place_comp.can_place(self):
			occupied = true 
			unit_on_tile = unit
	else: 
		print("This tile is occupied")


func unit_dead(unit: Unit): 
	occupied = false 
	unit_on_tile = null


func _on_area_3d_mouse_entered() -> void:
	if not occupied: 
		var on_hover_mat = StandardMaterial3D.new()
		on_hover_mat.albedo_color = Color("e8af7e")
		mesh.material_override = on_hover_mat


func _on_area_3d_mouse_exited() -> void:
	var normal_mat = StandardMaterial3D.new()
	normal_mat.albedo_color = colour
	mesh.material_override = normal_mat


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				place_unit()
				

func path_find(): 
	ray_casts.get_neighbours()
