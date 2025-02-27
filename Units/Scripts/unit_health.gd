extends Node3D


var max_health
var health 
var armour 
@onready var health_bar_node = $SubViewport/health_bar
@onready var timer = $heal_colour


@onready var stats = $"../../stats_n3D"

@onready var normal_style_box 
@onready var heal_style_box 

func _ready() -> void:
	await get_tree().process_frame
	
	max_health = stats.max_health
	health = max_health
	armour = stats.armour
	
	normal_style_box = StyleBoxFlat.new()
	normal_style_box.bg_color = Color("ff0000")
	
	heal_style_box = StyleBoxFlat.new()
	heal_style_box.bg_color = Color("29b569")
	
	if health_bar_node: 
		health_bar_node.max_value = max_health
		health_bar_node.value = health
		health_bar_node.add_theme_stylebox_override("fill", normal_style_box)
		

func heal(value): 
	health = health + value
	health_bar_node.value = health
	health_bar_node.add_theme_stylebox_override("fill", heal_style_box)
	
	if self.visible == false: 
		self.visible = true
	
	if health > max_health: 
		health = max_health
	timer.start()


func damage_mitigation(damage) -> float: 
	return (float(damage) / (1.0 + (armour / 100.0)))


func take_damage(damage): 
	var post_mitigation_damage = damage_mitigation(damage)
	health -= post_mitigation_damage
	
	if health <= 0: 
		get_parent().on_death()
	health_bar_node.value = health
	self.visible = true
 

func _on_heal_colour_timeout() -> void:
	health_bar_node.add_theme_stylebox_override("fill", normal_style_box)
	if health == max_health: 
		self.visible = false
