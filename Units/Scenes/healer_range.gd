extends Node3D

var friendlies_in_range = []

@onready var heal_node = $"../heal_n3D"

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("friendly_unit"): 
		friendlies_in_range.append(area)
		heal_node.update_friendlies_in_range(friendlies_in_range)

func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.is_in_group("friendly_unit"): 
		if area in friendlies_in_range: 
			friendlies_in_range.erase(area)
			heal_node.update_friendlies_in_range(friendlies_in_range)
