extends CharacterBody3D
class_name Enemy

var path 
#var path_segment = 0
var blocked = false 
var blocked_by
var block_required

var next_block 
var next_block_entry
var next_block_edge_dict
var to_edge = true
var roadblocked = false
var roadblock_instance

var current_tile

var SPEED 
var attack_damage 
var colour 

var timer = Timer.new()


@onready var health_node = $health
@onready var stats = $stats
@onready var attack_node = $attack

var random_offset 
var offset = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame  # Ensures nodes are ready
	game_speed_subscribe()
	timer.autostart = false
	timer.one_shot = true
	timer.wait_time = 1.0 / GameSpeed.game_speed
	timer.timeout.connect(on_road_timeout)
	add_child(timer)
	if stats:
		#SPEED = stats.SPEED
		#block_required = stats.block_required
		colour = stats.colour
	
	#random_offset = Vector3(randf_range(-1 * offset, offset), 0, randf_range(-1 * offset, offset))
	#position = position + random_offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if not roadblocked: 
		#movement(delta)
	#
	#elif roadblocked:
		#destroy_roadblock()
	#
	#if blocked: 
		#attack_node.attack(blocked_by)


#func movement(delta: float):
	## TODO: Can be optimised if needed 
	#get_self_pos_relative_to_block()
	#var target_pos
	#
	#if to_edge: 
		#if next_block_entry == "south": target_pos = next_block_edge_dict["south"]
		#elif next_block_entry == "north": target_pos = next_block_edge_dict["north"]
		#elif next_block_entry == "west": target_pos = next_block_edge_dict["west"]
		#elif next_block_entry == "east": target_pos = next_block_edge_dict["east"]
	#else: 
		#target_pos = Vector3(next_block.global_position.x, global_position.y , next_block.global_position.z)
	#
	#target_pos = target_pos + random_offset
	#
	#if not blocked:
		#global_position = global_position.move_toward(target_pos, delta * SPEED * GameSpeed.game_speed)
		#if not global_position.is_equal_approx(target_pos):
			#look_at(target_pos)
	#
	#
	#if global_position.is_equal_approx(target_pos): 
		#if next_block.is_exit: 
			#at_exit()
			#return
		#
		#if not to_edge: 
			#next_block = next_block.next_block[path]
		#else: 
			#current_tile.remove_enemy_on_tile(self)
			#current_tile = next_block
			#current_tile.add_enemy_on_tile(self)
		#to_edge = not to_edge
		#
		#if next_block.roadblocked: 
			#roadblocked = true
			#roadblock_instance = next_block.roadblock_instance 
			#roadblock_instance.add_blocker(self)


#func get_self_pos_relative_to_block():
	#var self_current_pos = global_position
	#next_block_edge_dict = next_block.edge_dict 
	#
	#var closest 
	#var selected 
	#for entry in next_block_edge_dict: 
		#var distance = abs(self_current_pos - next_block_edge_dict[entry])
		#if closest == null or distance < closest:  
			#closest = distance
			#selected = entry
	#next_block_entry = selected


func on_road_timeout(): 
	if roadblock_instance != null:
		roadblock_instance.destroy()
		next_block.destroy_roadblock() 
		unroadblock()

func unroadblock(): 
	roadblocked = false
	roadblock_instance = null

#func destroy_roadblock(): 
	#if timer.is_stopped(): 
		#create_timer()


func create_timer(): 
	timer.start()


#func at_exit(): 
	#print("enemy exited")
	#GameSpeed.unsubscribe(self)
	#queue_free()

#func get_blocked(blocker: Unit): 
	#blocked = true 
	#blocked_by = blocker


#func hit(damage: int, unit: Unit):
	#health_node.on_hit(damage, unit)

#
#func unblock(): 
	#blocked = false 
	#blocked_by = null 

#func on_death(killed_by: Unit): 
	#killed_by.killed_enemy()
	#unsubscribe_game_speed()
	#if blocked_by: 
		#blocked_by.notify_death(self) 
	#self.queue_free()


func game_speed_subscribe(): 
	GameSpeed.subscribe(self)
	

func unsubscribe_game_speed():
	GameSpeed.unsubscribe(self)

func update_game_speed(val): 
	attack_node.update_game_speed(val)
	if not timer.is_stopped():
		var progress_ratio = timer.time_left / timer.wait_time  
		var new_wait_time = timer.wait_time / val  
		var interupt_val = new_wait_time * progress_ratio
		timer.start(interupt_val)  
		
	timer.wait_time = timer.wait_time / val  
