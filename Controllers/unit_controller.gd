extends Node3D

var ranged_unit_resource = preload("res://Units/Scenes/ranged_unit.tscn")
var ground_unit_resource = preload("res://Units/Scenes/ground_unit.tscn")
var healer_unit_resource = preload("res://Units/Scenes/healer_unit.tscn")
var mirror_unit_resource = preload("res://Units/Scenes/mirror.tscn")
var selected_unit 

var summon_units = []
var summon_placing = false

func _input(event):
	if Input.is_action_just_pressed("one"):
		unit_selected("one")
	elif Input.is_action_just_pressed("two"):
		unit_selected("two")
	elif Input.is_action_just_pressed("three"):
		unit_selected("three")
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT): 
		deselect_unit()
	elif Input.is_action_just_pressed("four"):
		unit_selected("four")

func unit_selected(unit):
	deselect_unit()
	
	if unit == "one":
		selected_unit = ground_unit_resource.instantiate()
	elif unit == "two": 
		selected_unit = ranged_unit_resource.instantiate()
	elif unit == "three":
		selected_unit = healer_unit_resource.instantiate()
	elif unit == "four" and len(summon_units) > 0: 
		selected_unit = summon_units[0][0].instantiate()
	
	if selected_unit != null: 
		get_tree().root.add_child(selected_unit)
		selected_unit = selected_unit.get_child(0)
		
		if unit == "four" and len(summon_units) > 0:
			selected_unit.parent_summon = summon_units[0][1]
	

func deselect_unit() -> void: 
	if selected_unit == null: 
		return
	# TODO: Bugged -> place 3, press 4, press RMB 
	if not selected_unit.placed:
		get_tree().root.remove_child(selected_unit.get_parent())
		selected_unit = null


func add_summon(summon, unit):
	summon_units.append([summon, unit]) 
