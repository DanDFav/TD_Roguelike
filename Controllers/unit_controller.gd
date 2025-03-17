extends Node3D

#var party = Party.party

var selected_unit 

var summon_units = []

var placeable_units = Party.party

var summon_placing = false

@onready var unit_display = $unit_display

func _ready() -> void:
	placeable_units = remove_duplicates(placeable_units)

func _input(event):
	if event: 
		for i in range(9):
			if Input.is_action_just_pressed(str(i + 1)) and len(placeable_units) > i:
				unit_selected(placeable_units[i])
				return  
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			deselect_unit()


func unit_selected(unit): 
	deselect_unit()
	var instance = Party.character_dictionary[unit]["Instance"]
	selected_unit = instance
	if instance is PackedScene: 
		selected_unit = selected_unit.instantiate()

	unit_display.unit_selected(unit)
	
	if selected_unit != null: 
		get_tree().root.add_child(selected_unit)
		selected_unit = selected_unit.get_child(0)


func placed(unit):
	unit_display.remove_button(unit, placeable_units)
	deselect_unit()
	selected_unit = null

func remove_unit_from_placeable(unit): 
	placeable_units.erase(unit)
	

func deselect_unit() -> void: 
	unit_display.deselect_buttons()
	if selected_unit == null: 
		return
	
	var selected_unit_placement_comp = selected_unit.get_node("placement_component_n3D")
	if not selected_unit_placement_comp.placed:
		get_tree().root.remove_child(selected_unit.get_parent())
		selected_unit = null


func add_summon(summon):
	placeable_units.append(summon)
	var icon_normal = Party.character_dictionary[summon]['Icon_normal']
	var icon_selected = Party.character_dictionary[summon]['Icon_hover']
	unit_display.create_texture_button(summon, icon_normal, icon_selected, 1)


func remove_duplicates(array):
	var new_array = []
	for item in array:
		if item not in new_array:
			new_array.append(item)
	return new_array
