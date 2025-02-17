extends Node3D

var row: int
var col: int 
var colour: Color
var height: float

@onready var mesh = $Block_Mesh
@onready var collision_shape = $CollisionShape3D


var unit_resource = preload("res://unit.tscn")

enum type {
	RANGE, 
	GROUND, 
	OUT_BOUND, 
	NONE
}



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
	print(height)
	add_child(unit)
	
	pass


func _on_area_3d_mouse_entered() -> void:
	var on_hover_mat = StandardMaterial3D.new()
	on_hover_mat.albedo_color = Color("e8af7e")
	
	#mat.material_override = 
