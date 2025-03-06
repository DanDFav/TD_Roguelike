extends StaticBody3D
class_name Unit

@onready var root = get_tree().root.get_node("Stage")
@onready var unit_controller = root.get_node("Unit_controller")
#@onready var morale_controller = root.get_node("morale_controller_n3D")

## block_collision: The area3D that checks to see if enemies should be blocked by this unit
@onready var block_collision = $enemy_collision_a3D 
@onready var stats = $stats_n3D
@onready var health_node = $health_n3D
@onready var clickable = $ability_collision_a3D/ability_collision_cb
@onready var attack_node = $attack_n3D
@onready var range_cb = $range_n3D/range_a3D/range_collision_cb
@onready var placement_comp = $placement_component_n3D

#var can_be_placed ## Can be either "Ground" / "Ranged" / "None"
var block_count
var currently_blocking = 0
var blocked_enemies = []
var blocked_queue = [] ## A Queue made up of enemies who can be blocked if a currently blocked enemy is removed 
var fixed_y: float = 1.5
#var placed = false 
var placed_on 
var selected = false
var on_place_skills = []
var on_kill_skill = []
var unit_cost : int

# For Summoned units only
var parent_summon 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame  # Ensures nodes are ready
	if stats:
		health_node.visible = false
		block_count = stats.block_count



func placed_func(block):
	placed_on = block 
	position.y = block.height 
	global_position.x = block.global_position.x 
	global_position.z = block.global_position.z 
	clickable.disabled = false
	range_cb.disabled = false
	unit_controller.placed(stats.unit_name)
	for skill in on_place_skills: 
		skill.call()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy") and currently_blocking < block_count: 
		block_enemy(body)

	elif body.is_in_group("enemy") and currently_blocking >= block_count: 
		blocked_queue.append(body)




## [b] Called by: [method _on_area_3d_body_entered] [/b] [br] [br]
## [b] Used for: Checks to see if the enemy is not already blocked, and that the unit has already been placed, 
## finally it checks to make sure its block count hasnt been reached. [br] 
## If those conditions are met, we let the enemy know it has been blocked, we add it to the
## [member blocked_enemies] array. Finally we increment our block count [br][br]
## [b] Calls: [method enemy_test.get_blocked], [method can_block_more_enemies]
func block_enemy(enemy : Node3D): 
	if enemy.blocked == false and placement_comp.placed and can_block_more_enemies() == true: 
		enemy.get_blocked(self)
		blocked_enemies.append(enemy)
		currently_blocking += enemy.block_required




## [b] Called by: [b] [method block_enemy] [br] [br]
## [b] Used for: [b] Checks if it can block any more enemies
func can_block_more_enemies() -> bool: 
	if currently_blocking <= block_count: 
		return true
	return false



## [b] Called By: [b] [method enemy_test.on_death] [br] [br]
## [b] Called When: [b] An enemy this unit is blocking dies [br] [br]
## [b] Used for: [b] Activates on kill effects [br] [br]
func killed_enemy(): 
	if len(on_kill_skill) > 0: 
		for skill in on_kill_skill: 
			skill.call()


## [b] Called By: [b] [method enemy_test.on_death] [br] [br]
## [b] Called When: [b] An enemy this unit is blocking dies [br] [br]
## [b] Use: [b] lets a blocker know to remove that enemy from blocked Queue / current block [br] [br]
func notify_death(enemy):
	if enemy in blocked_enemies:
		blocked_enemies.erase(enemy)
		currently_blocking -= enemy.block_required
	if enemy in blocked_queue: 
		blocked_queue.erase(enemy)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body in blocked_queue and body.is_in_group("enemy") == true:
		blocked_queue.erase(body)

func on_hit(damage): 
	health_node.take_damage(damage)


func on_death():
	placed_on.unit_dead(self)
	attack_node.unsubscribe_game_speed()
	for enemy in blocked_enemies: 
		enemy.unblock()
	get_parent().queue_free()


func on_click(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("DPS: ", attack_node.total_damage_dealt)


func add_on_placed_skill(skill): 
	on_place_skills.append(skill)


func add_on_kill_skill(skill): 
	on_kill_skill.append(skill)

func test():
	print("Test")
