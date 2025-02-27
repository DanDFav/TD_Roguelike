extends Node3D


var rate_of_fire
var damage

var enemies_in_range = []

@onready var hit_timer = $Timer
@onready var unit = get_parent()
@onready var stats = $"../../stats_n3D"


var current_enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame  # Ensures nodes are ready
	rate_of_fire = stats.rate_of_fire
	damage = stats.damage
	
	if hit_timer:
		hit_timer.wait_time = rate_of_fire


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if len(enemies_in_range) != 0 and hit_timer.is_stopped():
		hit_timer.start()

func enemy_entered_range(enemy): 
	enemies_in_range.append(enemy)

func enemy_left_range(enemy):
	enemies_in_range.erase(enemy)


func _on_timer_timeout() -> void:
	auto_attack()

func auto_attack(): 
	if len(get_parent().blocked_enemies) != 0:
		var enemy = get_parent().blocked_enemies[0]
		if is_instance_valid(enemy): 
			enemy.hit(damage, unit)
	elif len(enemies_in_range) != 0: 
		enemies_in_range[0].hit(damage, unit)
