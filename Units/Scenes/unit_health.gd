extends Node3D


@onready var max_health = 2000
@onready var health = max_health
@onready var health_bar_node = $SubViewport/health_bar
@onready var timer = $heal_colour


@onready var normal_style_box 
@onready var heal_style_box 

func _ready() -> void:
	await get_tree().process_frame
	
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


func take_damage(damage): 
	health -= damage
	if health <= 0: 
		get_parent().on_death()
	health_bar_node.value = health
	self.visible = true
	print(health)
 

func _on_heal_colour_timeout() -> void:
	health_bar_node.add_theme_stylebox_override("fill", normal_style_box)
	if health == max_health: 
		self.visible = false
