extends Node3D

@onready var root = get_tree().root.get_node("Stage")
@onready var morale_controller = root.get_node("morale_controller_n3D")
@onready var unit = $".."

var on_kill_increase = 1 


func _ready() -> void:
	unit.add_on_kill_skill(passive_one)

#On kill generate 1 morale 
func passive_one(): 
	morale_controller.increase_morale(on_kill_increase)
