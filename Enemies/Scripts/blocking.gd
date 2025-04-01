extends Node3D
class_name enemy_block

var blocked = false 
var blocked_by : Unit 
var block_required

@onready var stats = $"../stats"

func _ready() -> void:
	if stats:
		block_required = stats.block_required


func get_blocked(blocker: Unit): 
	blocked = true 
	blocked_by = blocker


func unblock(): 
	blocked = false 
	blocked_by = null 
