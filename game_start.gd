extends Node


@onready var started = false 
@onready var enemy_start = false 

@onready var subscribers = []

@onready var path_finished_count = 0

func start_game(): 
	if not started: 
		started = true 
		for i in subscribers: 
			i.notify_game_start()


func subscribe(subscriber): 
	subscribers.append(subscriber)


func unsubscribe(subscriber): 
	subscribers.erase(subscriber)

func path_found(): 
	path_finished_count += 1
	if path_finished_count == len(subscribers): 
		enemy_start = true

func map_updated(): 
	for i in subscribers: 
		i.map_updated()
