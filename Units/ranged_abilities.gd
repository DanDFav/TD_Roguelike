extends Node3D

@onready var unit = $".."

var unit_controller
@onready var root = get_tree().root.get_node("Stage")
var placement_comp 


func _ready() -> void:
	unit_controller = root.get_node("Unit_controller")
	unit.add_on_placed_skill(passive_skill_two)

func passive_skill_two(): 
	var mirror = preload("res://Units/Scenes/mirror.tscn").instantiate()
	mirror.get_node("unit_sb").parent_summon = unit
	Party.character_dictionary['Mirror_summon']["Instance"] = mirror
	unit_controller.add_summon('Mirror_summon')
	placement_comp = mirror.get_child(0).get_node("placement_component_n3D")


func _range_entered_mirror_skill(area: Area3D) -> void:
	if area.is_in_group("mirror"):
		placement_comp.can_be_placed = "ranged"


func _range_exited_mirror_skill(area: Area3D) -> void:
	if area.is_in_group("mirror"):
		placement_comp.can_be_placed = "none"
