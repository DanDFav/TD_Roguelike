extends Node3D

var gen_stage_script 
var spec_stage_script

var time = 0
var path_ready = false
var spawn_ready = false 
var spawn_info
 
var path_info
var grid_index

var enemy_resource = preload("res://enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var children = get_tree().root.get_child(0).get_children()
	for i in children: 
		if i.name == "Generic_stage_scrp":
			gen_stage_script = i 
	
	spec_stage_script = gen_stage_script.get_child(0)
	spec_stage_script.recieve_signal_from_spawner(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawn_ready == true: 
		time += 1
		print(time)
		
		for i in spawn_info: 
			print(i[1] * 100)
			if time == int(i[1] * 100): 
				spawn_enemy(i[0], i[1])

func recieve_spawn_info(grid_data, spawns, path_one):
	spawn_ready = true
	spawn_info = spawns
	grid_index = grid_data
	path_info = translate_path(path_one)

func translate_path(path_one): 
	var path = []
	
	
	
	for i in path_one: 
		var idx: int 
		idx = i.x * 10 + i.y
		path.append(grid_index[idx])
	
	return path

	
func spawn_enemy(enemy_type, time): 
	if enemy_type == 0.0: 
		var enemy = enemy_resource.instantiate()
		enemy.position.y = 0.5
		enemy.path = path_info
		add_child(enemy)
	pass
