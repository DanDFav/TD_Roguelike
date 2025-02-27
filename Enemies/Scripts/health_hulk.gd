extends Node3D


@onready var mesh = $"../MeshInstance3D"
@onready var hurt_timer = $Timer
@onready var stats = $"../stats"


var health 
var max_health 
var armour


func _ready() -> void:
	max_health = stats.max_health
	health = max_health
	armour = stats.armour

func on_hit(damage, unit): 
	health -= damage_mitigation(damage)
	if health <= 0: 
		on_death(unit)

	var on_hover_mat = StandardMaterial3D.new()
	on_hover_mat.albedo_color = Color("e80c0c")
	mesh.material_override = on_hover_mat
	hurt_timer.start()
	

func on_death(unit): 
	get_parent().on_death(unit)

func damage_mitigation(damage) -> float: 
	return (float(damage) / (1.0 + (armour / 100.0)))

func _on_timer_timeout() -> void:
	var on_hover_mat = StandardMaterial3D.new()
	on_hover_mat.albedo_color = get_parent().colour
	mesh.material_override = on_hover_mat
