extends Node3D

@onready var unit = $".."
@onready var attack_node = $"../attack_n3D"
@onready var rend =  preload("res://Units/Scenes/unit_abilities/rend.tscn")
@onready var health_node = $"../health_n3D"

@onready var p1_heal_val = 140


var applied_to: Array[Enemy] = []

var unit_controller
@onready var root = get_tree().root.get_node("Stage")


func _ready() -> void:
	unit_controller = root.get_node("Unit_controller")
	attack_node.add_on_hit_skill(passive_one)


func passive_one(enemy: Enemy):
	if enemy not in applied_to: 
		applied_to.append(enemy)
		var new_rend_inst = rend.instantiate()
		enemy.add_child(new_rend_inst)
		new_rend_inst.apply_rend(enemy, unit)
		
	else: 
		var rend_node = enemy.get_node("rend")
		rend_node.increment_stacks()

func passive_one_burst(): 
	health_node.heal(p1_heal_val)
	
	pass
