extends Node3D

var ranged_unit_resource = preload("res://Units/Scenes/ranged_unit.tscn")
var ground_unit_resource = preload("res://Units/Scenes/ground_unit.tscn")
var healer_unit_resource = preload("res://Units/Scenes/healer_unit.tscn")
var mirror_unit_resource = preload("res://Units/Scenes/mirror.tscn")
var scout_unit_resource  = preload("res://Units/Scenes/scout.tscn")

var party = Party.party



var selected_unit 

var summon_units = []
var summon_placing = false

func _input(event):
	if Input.is_action_just_pressed("one"):
		unit_selected(party[0])
	elif Input.is_action_just_pressed("two"):
		unit_selected(party[1])
	elif Input.is_action_just_pressed("three"):
		unit_selected(party[2])
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT): 
		deselect_unit()
	elif Input.is_action_just_pressed("four"):
		unit_selected(party[3])
	#elif Input.is_action_just_pressed("five"):
		#print("Five")
		#unit_selected("five")

func unit_selected(unit): 
	deselect_unit()
	
	selected_unit = unit.instantiate()
	if selected_unit != null: 
		get_tree().root.add_child(selected_unit)
		selected_unit = selected_unit.get_child(0)


## TODO: DO NOT DELETE
#func unit_selected(unit):
	#deselect_unit()
	#
	#if unit == "one":
		#selected_unit = ground_unit_resource.instantiate()
	#elif unit == "two": 
		#selected_unit = ranged_unit_resource.instantiate()
	#elif unit == "three":
		#selected_unit = healer_unit_resource.instantiate()
	#elif unit == "four": 
		#selected_unit = scout_unit_resource.instantiate()
	#elif unit == "five": 
		#if len(summon_units) > 0:
			#selected_unit = summon_units[0][0].instantiate()
		#else: return 
	#
	#
	#if selected_unit != null: 
		#get_tree().root.add_child(selected_unit)
		#selected_unit = selected_unit.get_child(0)
		#
		#if unit == "five" and len(summon_units) > 0:
			#selected_unit.parent_summon = summon_units[0][1]
	

func deselect_unit() -> void: 
	if selected_unit == null: 
		return
		
	if not selected_unit.placed:
		get_tree().root.remove_child(selected_unit.get_parent())
		selected_unit = null


func add_summon(summon, unit):
	summon_units.append([summon, unit]) 
