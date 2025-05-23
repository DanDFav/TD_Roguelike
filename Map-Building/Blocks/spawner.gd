extends Node3D
class_name Spawner


var row: int
var col: int

@export var path_number : int

var time = 0
var path_ready = false
var spawn_ready = false 
var spawn_info
 
var explored = false 
var is_exit = false

var roadblocked = false
var path_info = []
var grid_index

var path_next_block = {}
var path_position = {}
var path_node = {}
var next_node = {}
var next_block = {}

var enemies_on_tile = []


@onready var ray_casts := $ray_casts

var enemy_resource = preload("res://Enemies/Scenes/enemy_basic.tscn")
var enemy_hulk_resource = preload("res://Enemies/Scenes/enemy_hulk.tscn")
var enemy_dog_resource = preload("res://Enemies/Scenes/enemy_dog.tscn")
var enemy_range_resource = preload("res://Enemies/Scenes/enemy_ranged.tscn")

# If we have recieved the spawning data, we can start spawning enemies at their correct interval 
func _process(delta: float) -> void:
	if spawn_ready == true and GameStart.enemy_start: 
		time += delta
		time = snapped(time, 0.01) 
		if spawn_info:
			for i in spawn_info: 
				if time >= i[1] and i[1] >= time - delta and i[2] == path_number:  
					print(time)
					spawn_enemy(i[0], i[3])
					spawn_info.erase(i) 

#Is called by the specific stage script, sets some variables 
func recieve_spawn_info(grid_data, spawns, path):
	spawn_ready = true
	spawn_info = spawns
	grid_index = grid_data 
	#if path != null: 
		#path_info = translate_path(path)


#Takes in a list of path Vector2(x,y), and translates them into a dictionary key 
#E.g. Vector(4,1) becomes { "41": objectA }
#func translate_path(path_data): 
	#var path = [] 
	#for i in path_data: 
		#var idx: int 
		#idx = i.x * 10 + i.y
		#path.append(grid_index[idx])
	#return path

#Spawns an enemy, and sets its path 
func spawn_enemy(enemy_type, path): 
	#if path_number == 0: 
		#print("ERROR: PATH NUMBER EXPORT NOT SET")
	#var enemy : Enemy
	var enemy
	if enemy_type == 0: 
		enemy = enemy_resource.instantiate()
	elif enemy_type == 1: 
		enemy = enemy_hulk_resource.instantiate()
	elif enemy_type == 2: 
		enemy = enemy_dog_resource.instantiate()
	elif enemy_type == 3: 
		enemy = enemy_range_resource.instantiate()
	
	var enemy_movement = enemy.get_node("movement")
	
	enemy_movement.current_tile = self
	enemy.position.y = 0.5
	if path == 1: 
		enemy_movement.path = "path_one"
		enemy_movement.next_block = next_block[enemy_movement.path]

	elif path == 2: 
		enemy_movement.path = "path_two"
		enemy_movement.next_block = next_block[enemy_movement.path]
	add_child(enemy)


func add_enemy_on_tile(enemy):
	enemies_on_tile.append(enemy)

func remove_enemy_on_tile(enemy):
	enemies_on_tile.erase(enemy)
