extends Node3D
class_name Skill

@onready var timer = $Timer
@onready var timer_wait_time = 2.0 

@onready var progress_bar

var attached_to 
var attach_location : Vector3
var stack = 0

var applied_by 
var max_stacks = 3
var on_max_stacks = 135 

@onready var normal_style_box 


var enemy_viewport


func _process(delta: float) -> void:
	if attach_location: 
		global_position = attach_location
	pass
	

func append_new_progress_bar(): 
	enemy_viewport = attached_to.get_node("health").get_node("Progress_bar").get_node("SubViewport")
	var enemy_health_bar = enemy_viewport.get_node("ProgressBar")
	
	progress_bar = ProgressBar.new()
	normal_style_box = StyleBoxFlat.new()
	normal_style_box.bg_color = Color("7e00c1")
	
	var background_style_box = StyleBoxFlat.new()
	background_style_box.bg_color = Color("000000")
	
	progress_bar.max_value = max_stacks
	progress_bar.value = stack
	progress_bar.add_theme_stylebox_override("fill", normal_style_box)
	progress_bar.add_theme_stylebox_override("background", background_style_box)
	progress_bar.custom_minimum_size = Vector2(40, 8)
	progress_bar.set_anchors_preset(Control.PRESET_CENTER)
	progress_bar.show_percentage = false
	enemy_viewport.add_child(progress_bar)
	progress_bar.global_position = Vector2(enemy_health_bar.global_position.x, enemy_health_bar.global_position.y - 8)

func apply_rend(enemy, unit): 
	attached_to = enemy
	applied_by = unit
	
	append_new_progress_bar()
	
	#style_box()
	increment_stacks()

func increment_stacks(): 
	stack += 1
	progress_bar.value = stack
	if stack == max_stacks: 
		burst()
	
#	If enemy hasn't been hit in 2 seconds, remove the rend
	timer.start(timer_wait_time)

func burst(): 
	attached_to.get_node("health").on_hit(on_max_stacks, applied_by)
	applied_by.get_node("abilities_n3D").passive_one_burst()
	
	print("burst")
	stack = 0
	progress_bar.value = stack


func _on_timer_timeout() -> void:
	self.queue_free()
