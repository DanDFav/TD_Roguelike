extends Node3D


@onready var mesh = $"../MeshInstance3D"
@onready var hurt_timer = $Timer
@onready var stats = $"../stats"

@onready var health_bar_node = $Progress_bar/SubViewport/ProgressBar

@onready var normal_style_box 
@onready var heal_style_box 


var health
var max_health
var armour

func _ready() -> void:
	max_health = stats.max_health
	health = max_health
	armour = stats.armour
	
	normal_style_box = StyleBoxFlat.new()
	normal_style_box.bg_color = Color("ff0000")
	
	heal_style_box = StyleBoxFlat.new()
	heal_style_box.bg_color = Color("29b569")
	
	health_bar_node.max_value = max_health
	health_bar_node.value = health
	health_bar_node.add_theme_stylebox_override("fill", normal_style_box)

func on_hit(damage, unit): 
	health -= damage_mitigation(damage)	
	health_bar_node.value = health
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
	on_hover_mat.albedo_color = stats.colour
	mesh.material_override = on_hover_mat
