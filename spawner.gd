extends Node3D

var gen_stage_script 
var spec_stage_script

var time = 0
var path_ready = false
var spawn_ready = false 
var spawn_info
 
var path_info

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
	if path_ready == true and spawn_ready == true: 
		time += 1
		for i in spawn_info: 
			if time == (i[1] * 100): 
				spawn_enemy(i[0], i[1])

func recieve_spawn_info(enemy_spawns):
	print(enemy_spawns)
	spawn_ready = true
	spawn_info = enemy_spawns

func recieve_path_info(path_nodes):
	print(path_nodes)
	path_ready = true
	path_info = path_nodes
	
func spawn_enemy(enemy_type, time): 
	print("spawning ", enemy_type, "|| Time:  ", time)
	if enemy_type == 0.0: 
		var enemy = enemy_resource.instantiate()
		enemy.position.y = 0.5
		enemy.path = path_info
		add_child(enemy)
	pass
