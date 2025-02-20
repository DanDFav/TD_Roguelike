extends Node3D

var ranged_unit_resource = preload("res://Units/Scenes/ranged_unit.tscn")
var ground_unit_resource = preload("res://Units/Scenes/ground_unit.tscn")
var healer_unit_resource = preload("res://Units/Scenes/healer_unit.tscn")
var selected_unit 


func _input(event):
	if Input.is_action_just_pressed("one"):
		unit_selected("one")
	elif Input.is_action_just_pressed("two"):
		unit_selected("two")
	elif Input.is_action_just_pressed("three"):
		unit_selected("three")
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT): 
		deselect_unit()

func unit_selected(unit):
	deselect_unit()
	
	if unit == "one":
		selected_unit = ground_unit_resource.instantiate()
	elif unit == "two": 
		selected_unit = ranged_unit_resource.instantiate()
	elif unit == "three":
		selected_unit = healer_unit_resource.instantiate()
	get_tree().root.add_child(selected_unit)
	selected_unit = selected_unit.get_child(0)

func deselect_unit() -> void: 
	if selected_unit == null: 
		return
	if not selected_unit.placed:
		get_tree().root.remove_child(selected_unit.get_parent())
		selected_unit = null
