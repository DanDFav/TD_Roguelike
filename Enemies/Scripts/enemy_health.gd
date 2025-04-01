extends Node3D
class_name Enemy_health

@onready var mesh = $"../MeshInstance3D"
@onready var hurt_timer = $Timer
@onready var stats = $"../stats"
@onready var block_node = $"../blocking"

@onready var health_bar_node = $Progress_bar/SubViewport/ProgressBar

@onready var normal_style_box 
@onready var heal_style_box 


var timer_wait_time = 0.15 / GameSpeed.game_speed

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
	
	self.visible = false

func on_hit(damage: int, unit: Unit): 
	health -= damage_mitigation(damage)
	self.visible = true
	health_bar_node.value = health
	if health <= 0: 
		on_death(unit)
	
	var on_hover_mat = StandardMaterial3D.new()
	on_hover_mat.albedo_color = Color("e80c0c")
	mesh.material_override = on_hover_mat
	hurt_timer.start(timer_wait_time)
	

func on_death(killed_by: Unit): 
	killed_by.killed_enemy()
	#unsubscribe_game_speed()
	if block_node.blocked_by: 
		block_node.blocked_by.notify_death(self.get_parent()) 
	self.get_parent().queue_free()

func damage_mitigation(damage: int) -> float: 
	return (float(damage) / (1.0 + (armour / 100.0)))


func _on_timer_timeout() -> void:
	var on_hover_mat = StandardMaterial3D.new()
	on_hover_mat.albedo_color = stats.colour
	mesh.material_override = on_hover_mat
