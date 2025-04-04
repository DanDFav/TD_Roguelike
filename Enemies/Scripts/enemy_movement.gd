extends Node3D
class_name enemy_movement

@onready var stats = $"../stats"
@onready var block_node = $"../blocking"

var SPEED 
var random_offset 
var offset = 0.1

var attack_pause

var next_block 
var next_block_entry
var next_block_edge_dict
var to_edge = true
var roadblocked = false
var roadblock_instance

var timer_roadblock = Timer.new()
var timer_attack_pause = Timer.new() 

var timers = []

var path 
var current_tile

@onready var parent = get_parent()

func _ready() -> void:
	if stats:
		SPEED = stats.SPEED
	
	setup_timer(timer_roadblock, on_road_timeout)
	setup_timer(timer_attack_pause, attack_pause_end)
	
	random_offset = Vector3(randf_range(-1 * offset, offset), 0, randf_range(-1 * offset, offset))
	parent.position = parent.position + random_offset

func setup_timer(timer, connection): 
	timer.autostart = false
	timer.one_shot = true
	timer.wait_time = 1.0
	timer.timeout.connect(connection)
	add_child(timer)
	timers.append(timer)


func _process(delta: float) -> void:
	if not roadblocked: 
		movement(delta)
	
	elif roadblocked:
		destroy_roadblock()


func movement(delta: float):
	# TODO: Can be optimised if needed 
	get_self_pos_relative_to_block()
	var target_pos
	var test = parent.global_position
	
	if attack_pause == true:
		return 
	
	if to_edge: 
		if next_block_entry == "south": target_pos = next_block_edge_dict["south"]
		elif next_block_entry == "north": target_pos = next_block_edge_dict["north"]
		elif next_block_entry == "west": target_pos = next_block_edge_dict["west"]
		elif next_block_entry == "east": target_pos = next_block_edge_dict["east"]
	else: 
		target_pos = Vector3(next_block.global_position.x, parent.global_position.y , next_block.global_position.z)
	
	target_pos = target_pos + random_offset
	
	if not block_node.blocked:
		parent.global_position = parent.global_position.move_toward(target_pos, delta * SPEED)
		if not parent.global_position.is_equal_approx(target_pos):
			parent.look_at(target_pos)
	
	
	if parent.global_position.is_equal_approx(target_pos): 
		if not to_edge: 
			if next_block.is_exit: 
				at_exit()
				return
			next_block = next_block.next_block[path]

		else: 
			current_tile.remove_enemy_on_tile(self)
			current_tile = next_block
			current_tile.add_enemy_on_tile(self)
		to_edge = not to_edge
		
		if next_block.roadblocked: 
			roadblocked = true
			roadblock_instance = next_block.roadblock_instance 
			roadblock_instance.add_blocker(self)

func get_self_pos_relative_to_block():
	var self_current_pos = parent.global_position
	next_block_edge_dict = next_block.edge_dict 
	
	var closest 
	var selected 
	for entry in next_block_edge_dict: 
		var distance = abs(self_current_pos - next_block_edge_dict[entry])
		if closest == null or distance < closest:  
			closest = distance
			selected = entry
	next_block_entry = selected

func destroy_roadblock(): 
	if timer_roadblock.is_stopped(): 
		create_timer_roadblock()

func create_timer_roadblock(): 
	timer_roadblock.start()

func on_road_timeout(): 
	print("called")
	if roadblock_instance != null:
		roadblock_instance.destroy()
		next_block.destroy_roadblock() 
		unroadblock()

func unroadblock(): 
	roadblocked = false
	roadblock_instance = null

func at_exit(): 
	print("enemy exited")
	get_parent().queue_free()

func attack_pause_start():
	attack_pause = true
	if timer_attack_pause.is_stopped(): 
		timer_attack_pause.start()
	

func attack_pause_end():
	attack_pause = false
	pass
