extends Node3D


@onready var stats = $"../stats"
@onready var controller = $".."
@onready var timer = $Timer

var damage = 80
var attack_speed = 0.8

var blocked_by 
var can_attack = false

func attack(blocker): 
	blocked_by = blocker
	timer.wait_time = attack_speed
	if can_attack: 
		can_attack = false
		blocker.on_hit(damage)
		pass
	else: 
		if timer.is_stopped(): timer.start()


func _on_timer_timeout() -> void:
	can_attack = true
