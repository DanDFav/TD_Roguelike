extends StaticBody3D

@onready var root = get_tree().root.get_child(0)
@onready var unit_controller = root.get_child(3)


@onready var mesh_collision   = $mesh_collision
@onready var enemey_collision = $Area3D/enemy_collision
@onready var range_collision  = $range/Area3D/range_collision
@onready var direction_indicator = $direct_indicator
@onready var stats = $"../Stats"
@onready var health_node = $health


var can_be_placed 
var block_count
var currently_blocking = 0
var blocked_enemies = []
var blocked_queue = []

var fixed_y: float = 1.5

var placed = false 
var placed_on 


var augments = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame  # Ensures nodes are ready
	if stats:
		health_node.visible = false
		block_count = stats.block_count
		can_be_placed = stats.can_be_placed
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if len(blocked_enemies) == 0: 
		check_enemies_for_block()
	if not placed: 
		position = get_mouse_world_position()


func check_enemies_for_block(): 
	for body in $Area3D.get_overlapping_bodies():
		if body.is_in_group("enemy"):
			block_enemy(body)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy") and currently_blocking < block_count: 
		block_enemy(body)

	elif body.is_in_group("enemy") and currently_blocking >= block_count: 
		blocked_queue.append(body)


#func block_enemy(enemy): 
	#if enemy.blocked == false: 
		#currently_blocking += 1
		#blocked_enemies.append(enemy)
		#enemy.get_blocker(self)

func block_enemy(enemy): 
	if enemy.blocked == false: 
		if enemy.get_blocker(self) == true: 
			blocked_enemies.append(enemy)
			currently_blocking += enemy.block_required



func can_place(block): 
	if not placed: 
		if block.is_in_group("ground_block") and can_be_placed == "ground": 
			place_unit(block)
			return true
		
		elif block.is_in_group("ranged_block") and can_be_placed == "ranged": 
			place_unit(block)
			return true
	
	return false

func place_unit(block): 
	placed = true
	placed_on = block 
	position.y = block.height 
	global_position.x = block.global_position.x 
	global_position.z = block.global_position.z 


func _input(event) -> void: 
	if not placed: 
		if event is InputEventMouseButton: 
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				self.rotate_y(-1.571 / 2.0)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				self.rotate_y(1.571 / 2.0)

func notify_death(enemy):
	if enemy in blocked_enemies:
		blocked_enemies.erase(enemy)
		currently_blocking -= enemy.block_required
	if enemy in blocked_queue: 
		blocked_queue.erase(enemy)

func get_mouse_world_position() -> Vector3:
	var camera = get_viewport().get_camera_3d()
	if not camera:
		return Vector3()
	
	var mouse_pos = get_viewport().get_mouse_position() 
	mouse_pos.y = get_viewport().get_mouse_position().y 
	
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_dir = camera.project_ray_normal(mouse_pos)
	
	var t = (fixed_y - ray_origin.y) / ray_dir.y  
	if t < 0:
		return Vector3()  
	
	var world_pos = ray_origin + ray_dir * t
	
	return Vector3(world_pos.x, fixed_y, world_pos.z)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body in blocked_queue and body.is_in_group("enemy") == true:
		blocked_queue.erase(body)

func on_hit(damage): 
	health_node.take_damage(damage)


#var blocked = false 
#var blocked_by
func on_death():
	for enemy in blocked_enemies: 
		enemy.unblock()
		pass
	get_parent().queue_free()
