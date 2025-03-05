extends Node3D
class_name Enemy_attack


@onready var stats = $"../stats"
@onready var controller = $".."
@onready var hit_timer = $Timer




var damage 
var attack_speed

var blocked_by 
var can_attack = false


func _ready() -> void:
	damage = stats.damage
	attack_speed = stats.attack_speed
	hit_timer.wait_time = attack_speed / GameSpeed.game_speed
	game_speed_subscribe()


func attack(blocker: Unit): 
	blocked_by = blocker
	if can_attack: 
		can_attack = false
		blocker.on_hit(damage)
	else: 
		if hit_timer.is_stopped(): hit_timer.start()


func _on_timer_timeout() -> void:
	can_attack = true

func game_speed_subscribe(): 
	GameSpeed.subscribe(self)

func unsubscribe_game_speed():
	GameSpeed.unsubscribe(self)

func update_game_speed(val): 
	if not hit_timer.is_stopped():
		var progress_ratio = hit_timer.time_left / hit_timer.wait_time  
		var new_wait_time = attack_speed / val  
		var interupt_val = new_wait_time * progress_ratio
		hit_timer.start(interupt_val)  
		
	hit_timer.wait_time = attack_speed / val  
