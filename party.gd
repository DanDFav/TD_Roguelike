extends Node


var party = [preload("res://Units/Scenes/ground_unit.tscn"), preload("res://Units/Scenes/ranged_unit.tscn"), preload("res://Units/Scenes/healer_unit.tscn"),
			preload("res://Units/Scenes/scout.tscn")]


func add_to_party(unit): 
	party.append(unit)

func remove_from_party(unit):
	party.erase(unit)
