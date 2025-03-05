extends Node


@onready var game_speed = 1.0

var speed_up = false

var subscribers = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space"): 
		if speed_up: 
			game_speed = 1.0
			speed_up = !speed_up
		else: 
			game_speed = 1.75
			speed_up = !speed_up
		
		update_game_speed()


func subscribe(node):
	subscribers.append(node)

func unsubscribe(node): 
	subscribers.erase(node)

func update_game_speed(): 
	for sub in subscribers: 
		sub.update_game_speed(float(game_speed))
