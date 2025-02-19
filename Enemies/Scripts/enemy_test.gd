extends CharacterBody3D

var path 
var path_segment = 0
var blocked = false 
var blocked_by
var block_required

var SPEED 
var attack_damage 
var colour 

@onready var health_node = $health
@onready var stats = $stats
@onready var attack_node = $attack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame  # Ensures nodes are ready
	if stats:
		SPEED = stats.SPEED
		block_required = stats.block_required
		colour = stats.colour


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not blocked:
		global_position = global_position.move_toward(Vector3(path[path_segment].global_position.x, global_position.y , path[path_segment].global_position.z), delta* SPEED)
	
	if global_position == Vector3(path[path_segment].global_position.x, global_position.y, path[path_segment].global_position.z): 
		path_segment = clamp(path_segment + 1, 0, len(path) -1 )
	
	if blocked: 
		attack_node.attack(blocked_by)


func get_blocker(blocker): 
	var blocker_block_count = blocker.block_count
	var blocker_current_block = blocker.currently_blocking
	blocked_by = blocker
	if blocker_current_block <= blocker_block_count: 
		blocked = true 

func hit(damage):
	health_node.on_hit(damage)
	

func on_death(): 
	if blocked_by: 
		blocked_by.notify_death(self) 
	self.queue_free()
	
