extends Node3D

var row: int
var col: int 
@export var colour: Color
@export var height: float

@onready var mesh = $MeshInstance3D

var occupied = false 
var unit_on_tile 

@onready var root = get_tree().root.get_child(0)
@onready var unit_controller = root.get_child(3)

func place_unit(): 
	var unit = unit_controller.selected_unit
	if not occupied and unit != null: 
		if unit.can_place(self):
			print("Placed Unit at", Vector2(row, col))
			occupied = true 
			unit_on_tile = unit
	else: 
		print("This tile is occupied")


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
