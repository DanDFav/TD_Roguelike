extends Node3D

var row: int
var col: int 
@export var colour: Color
@export var height: float

@onready var mesh = $MeshInstance3D

var unit_resource = preload("res://unit.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func place_unit(): 
	print("Placed Unit at", Vector2(row, col))
	var unit = unit_resource.instantiate()
	unit.position.y = height 
	add_child(unit)


func _on_area_3d_mouse_entered() -> void:
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
