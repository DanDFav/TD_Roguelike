extends CharacterBody3D
class_name Enemy

#var path = []
#var path_segment = 0
var blocked = false 
var blocked_by
var block_required

var next_block 

var SPEED 
var attack_damage 
var colour 

@onready var health_node = $health
@onready var stats = $stats
@onready var attack_node = $attack

var random_offset 
var offset = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame  # Ensures nodes are ready
	if stats:
		SPEED = stats.SPEED
		block_required = stats.block_required
		colour = stats.colour
	
	random_offset = Vector3(randf_range(-1 * offset, offset), 0, randf_range(-1 * offset, offset))
	position = position + random_offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if next_block: 
		var target_pos = Vector3(next_block.global_position.x, global_position.y , next_block.global_position.z)
		target_pos = target_pos + random_offset
		
		if not blocked:
			global_position = global_position.move_toward(target_pos, delta * SPEED * GameSpeed.game_speed)
			if not global_position.is_equal_approx(target_pos):
				look_at(target_pos)
			
		
		if global_position.is_equal_approx(target_pos): 
			if next_block.is_this_exit: 
				at_exit()
				return
			next_block = next_block.exit
			if next_block.roadblocked: 
				next_block = null	
	if blocked: 
		attack_node.attack(blocked_by)


func at_exit(): 
	print("enemy exited")
	queue_free()

func get_blocked(blocker: Unit): 
	blocked = true 
	blocked_by = blocker


func hit(damage: int, unit: Unit):
	health_node.on_hit(damage, unit)


func unblock(): 
	blocked = false 
	blocked_by = null 

func on_death(killed_by: Unit): 
	killed_by.killed_enemy()
	attack_node.unsubscribe_game_speed()
	if blocked_by: 
		blocked_by.notify_death(self) 
	self.queue_free()
