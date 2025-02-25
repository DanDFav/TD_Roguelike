extends Node3D


@onready var unit = $".."

var attack_node

func _ready() -> void:
	await get_tree().process_frame  # Ensures nodes are ready
	if unit:
		attack_node = unit.parent_summon.get_node("attack_n3D")
	pass


func body_entered_attack_range(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		attack_node.enemy_entered_range(body)
		pass


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		attack_node.enemy_left_range(body)
		pass
 
