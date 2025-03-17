extends Node

@onready var character_dictionary = {
	"Ground_unit": {"Status": true, 
					"Icon": null,
					"Instance": preload("res://Units/Scenes/ground_unit.tscn"),
					"Icon_normal": load("res://Units/Thumbnails/ground_unit.png"), 
					"Icon_hover": load("res://Units/Thumbnails/ground_unit_hover.png") },
					 
	"Ranged_unit": {"Status": true, 
					"Icon": null,
					"Instance": preload("res://Units/Scenes/ranged_unit.tscn"),
					"Icon_normal": load("res://Units/Thumbnails/ranged_unit.png"), 
					"Icon_hover": load("res://Units/Thumbnails/ranged_unit_hover.png") }, 
					
	"Scout_unit": {"Status": true,
					"Icon": null, 
					"Instance": preload("res://Units/Scenes/scout.tscn"),
					"Icon_normal": load("res://Units/Thumbnails/scout_unit.png"), 
					"Icon_hover": load("res://Units/Thumbnails/scout_unit_hover.png") }, 
					
	"Healer_unit": {"Status": true, 
					"Icon": null, 
					"Instance": preload("res://Units/Scenes/healer_unit.tscn"),
					"Icon_normal": load("res://Units/Thumbnails/Healer_unit.png"), 
					"Icon_hover": load("res://Units/Thumbnails/Healer_unit_hover.png") }, 
	
	"Mace_unit": {"Status": true, 
					"Icon": null, 
					"Instance": preload("res://Units/Scenes/mace_unit.tscn"),
					"Icon_normal": load("res://Units/Thumbnails/Mace_unit.png"), 
					"Icon_hover": load("res://Units/Thumbnails/Mace_unit_hover.png") }, 

	"Roadblock": {"Status": true, 
					"Icon": null, 
					"Instance": preload("res://Units/Scenes/roadblock.tscn"),
					"Icon_normal": load("res://Units/Thumbnails/roadblock.png"), 
					"Icon_hover": load("res://Units/Thumbnails/roadblock_hover.png") }, 
	
	"Mirror_summon": { 
				"Icon": null, 
				"Instance": preload("res://Units/Scenes/mirror.tscn"),
				"Icon_normal": load("res://Units/Thumbnails/mirror.png"),
				"Icon_hover": load("res://Units/Thumbnails/mirror_hover.png")
	}
}

var party = ["Ground_unit", "Ranged_unit", "Scout_unit", "Healer_unit", "Mace_unit"]

func add_to_party(unit): 
	party.append(unit)

func remove_from_party(unit):
	party.erase(unit)
