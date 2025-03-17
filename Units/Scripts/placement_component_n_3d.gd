extends Node3D

@onready var root = get_tree().root.get_node("Stage")
var can_be_placed ## Can be either "Ground" / "Ranged" / "None"
var placed = false 
@onready var morale_controller = root.get_node("morale_controller_n3D")
var placed_on 
var unit_cost : int
var fixed_y: float = 1.5
@onready var stats = $"../stats_n3D"
var parent_node 

func _ready() -> void:
	await get_tree().process_frame  # Ensures nodes are ready
	parent_node = get_parent()
	print("Parent Node: ", parent_node.get_class())
	if stats:
		can_be_placed = stats.can_be_placed
		unit_cost = stats.morale_cost


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not placed: 
		parent_node.position = get_mouse_world_position()


## [b] Called by: [b] [block.place_unit] [br] [br]
## [b] Used for: [b] If the unit hasnt been placed yet, we check the group the unit is in, then check
## That the block it is trying to be placed on matches that group, and that we have enough morale to place it. [br] [br]
## Returns true if can be placed, false otherwise. [br] [br]
## [b] Calls: [b] [method morale_controller.get_morale()], [method place_unit]
func can_place(block): 
	if not placed: 
		if block.is_in_group("ground_block") and can_be_placed == "ground" and morale_controller.get_morale() >= unit_cost: 
			if parent_node is Roadblock: 
				var enemy_count = len(block.enemies_on_tile)
				if enemy_count != 0: 
					return false
			#place_unit(block)
			return true
		
		elif block.is_in_group("ranged_block") and can_be_placed == "ranged" and morale_controller.get_morale() >= unit_cost: 
			#place_unit(block)
			return true
	
	return false


func _input(event) -> void: 
	if not placed: 
		if event is InputEventMouseButton: 
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				parent_node.rotate_y(-1.571 / 2.0)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				parent_node.rotate_y(1.571 / 2.0)
		
		if event is InputEventKey: 
			if event.is_action_pressed("q"):
				parent_node.rotate_y(-1.571)
			elif event.is_action_pressed("e"): 
				parent_node.rotate_y(1.571)


## [b] Called by: [b] [method can_place] [br] [br]
## [b] Used for: [b] Places the unit. Enables / Disables certain collision objects / area3d's. [br] [br]
## [b] Calls: [b] [method morale_controller.spend_morale], [method unit_controller.placed]
func place_unit(block): 
	morale_controller.spend_morale(unit_cost)
	placed = true
	if parent_node is Unit: 
		parent_node.placed_func(block)
	elif parent_node is Roadblock: 
			parent_node.placed_func(block)

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
