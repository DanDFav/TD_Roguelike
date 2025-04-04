extends Node3D

@onready var stats = $"../stats"
@onready var controller = $".."
@onready var hit_timer = $Timer
@onready var block_node = $"../blocking"
@onready var range_node = $"../range"
@onready var movement_node = $"../movement"

var damage 
var attack_speed
var can_attack = true

var hit = 0

func _ready() -> void:
	damage = stats.damage
	attack_speed = stats.attack_speed
	hit_timer.wait_time = attack_speed 
	


func _process(delta: float) -> void:
	if range_node.are_units_in_range():
		var unit_to_hit = range_node.get_unit_to_attack()
		attack(unit_to_hit)


func attack(blocker: Unit): 
	if can_attack: 
		can_attack = false
		blocker.on_hit(damage)
		movement_node.attack_pause_start()
		print(GameSpeed.game_time, "|  Hit Count: ", hit)
		hit += 1 
	else: 
		if hit_timer.is_stopped(): hit_timer.start()


func _on_timer_timeout() -> void:
	can_attack = true
