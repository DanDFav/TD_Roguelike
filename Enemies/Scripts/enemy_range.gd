extends Node3D


var units_in_range = []

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("friendly_unit"):
		units_in_range.append(area.get_parent())
		print(units_in_range)


func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.is_in_group("friendly_unit"):
		units_in_range.erase(area.get_parent())


func are_units_in_range(): 
	if len(units_in_range) > 0: 
		return true
	else: return false 


func get_unit_to_attack(): 
	var highest 
	var selected
	
	for unit in units_in_range: 
		if highest == null: 
			highest = unit.placed_order
			selected = unit
		elif unit.placed_order > highest: 
			highest = unit.placed_order
			selected = unit
	
	return selected
