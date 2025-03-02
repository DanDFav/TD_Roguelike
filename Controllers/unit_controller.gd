extends Node3D

#var party = Party.party

var selected_unit 

var summon_units = []

var placeable_units = Party.party

var summon_placing = false

@onready var unit_display = $unit_display

func _input(event):
	if Input.is_action_just_pressed("one") and len(placeable_units) >= 1: 
		unit_selected(placeable_units[0])
	elif Input.is_action_just_pressed("two") and len(placeable_units) >= 2:
		unit_selected(placeable_units[1])
	elif Input.is_action_just_pressed("three") and len(placeable_units) >= 3:
		unit_selected(placeable_units[2])
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT): 
		deselect_unit()
	elif Input.is_action_just_pressed("four") and len(placeable_units) >= 4:
		unit_selected(placeable_units[3])
	elif Input.is_action_just_pressed("five") and len(placeable_units) >= 5:
		unit_selected(placeable_units[4])

func unit_selected(unit): 
	deselect_unit()
	selected_unit = Party.character_dictionary[unit]["Instance"]
	
	unit_display.unit_selected(unit)
	
	print(selected_unit)
	if selected_unit != null: 
		get_tree().root.add_child(selected_unit)
		selected_unit = selected_unit.get_child(0)


func placed(unit):
	unit_display.remove_button(unit)
	placeable_units.erase(unit)
	deselect_unit()

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
	unit_display.deselect_buttons()
	if selected_unit == null: 
		return
	
	if not selected_unit.placed:
		get_tree().root.remove_child(selected_unit.get_parent())
		selected_unit = null
		


func add_summon(summon):
	placeable_units.append(summon)
	var icon_normal = Party.character_dictionary[summon]['Icon_normal']
	var icon_selected = Party.character_dictionary[summon]['Icon_hover']
	unit_display.create_texture_button(summon, icon_normal, icon_selected)
