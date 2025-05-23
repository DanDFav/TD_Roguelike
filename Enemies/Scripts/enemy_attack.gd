extends Node3D
class_name Enemy_attack


@onready var stats = $"../stats"
@onready var controller = $".."
@onready var hit_timer = $Timer
@onready var block_node = $"../blocking"

var damage 
var attack_speed

var can_attack = false


func _ready() -> void:
	damage = stats.damage
	attack_speed = stats.attack_speed
	hit_timer.wait_time = attack_speed 


func _process(delta: float) -> void:
	if block_node.blocked: 
		attack(block_node.blocked_by)


func attack(blocker: Unit): 
	if can_attack: 
		can_attack = false
		blocker.on_hit(damage)
	else: 
		if hit_timer.is_stopped(): hit_timer.start()


func _on_timer_timeout() -> void:
	can_attack = true
