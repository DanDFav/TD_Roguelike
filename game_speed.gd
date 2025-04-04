extends Node

var speed_up = false

var game_time : float

#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	game_time += (delta )

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space"): 
		print("update")
		if speed_up: 
			Engine.time_scale = 1.0
			speed_up = !speed_up
		else: 
			Engine.time_scale = 1.75
			speed_up = !speed_up
