extends Node3D
class_name path_find_ray_cast

@onready var parent_block = get_parent()

@onready var up    = $Up
@onready var down  = $Down
@onready var left  = $Left
@onready var right = $Right

var position_vec

func _ready() -> void:
	await get_tree().process_frame
	position_vec = Vector2(parent_block.row, parent_block.col)

func find_path_to_spawner():
	var queue = []
	var visited = {}
	var came_from = {}

	# Start from this block
	queue.append(parent_block)
	visited[parent_block] = true
	came_from[parent_block] = null

	while queue.size() > 0:
		var current = queue.pop_front()

		# If we found the spawner, reconstruct and store the path
		if current is Spawner:
			set_path_references(came_from, current)
			return true

		# Get neighbors
		var neighbors = get_neighbors(current)
		
		
		for neighbor in neighbors:
			if neighbor not in visited:
				queue.append(neighbor)
				visited[neighbor] = true
				came_from[neighbor] = current
	return false  

# Helper function to get valid neighbors
func get_neighbors(block):
	var neighbors = []
	var ray_casts = block.get_node("ray_casts")
	var up_collider    = ray_casts.up.get_collider()
	var down_collider  = ray_casts.down.get_collider()
	var left_collider  = ray_casts.left.get_collider()
	var right_collider = ray_casts.right.get_collider()

	for collider in [up_collider, down_collider, left_collider, right_collider]:
		if collider and collider.is_in_group("ground_block") and not collider.roadblocked:
			neighbors.append(collider)

	return neighbors

# **Set the path references**
func set_path_references(came_from, end_block):
	var current = end_block
	while current != null:
		var previous = came_from.get(current, null)
		if previous:  # Set reference to the next block in the shortest path
			current.exit = previous
		#change_mat(current, Color(0, 1, 0))  # Green for the optimal path
		current = previous

func change_mat(node, colour): 
	var material = StandardMaterial3D.new()
	material.albedo_color = colour
	
	var mesh = node.get_node("MeshInstance3D")
	if mesh: 
		mesh.set_surface_override_material(0, material)
