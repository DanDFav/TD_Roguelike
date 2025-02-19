extends Node3D

@onready var attack_node = $"../attack"

func body_entered_attack_range(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		attack_node.enemy_entered_range(body)
		


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		attack_node.enemy_left_range(body)
