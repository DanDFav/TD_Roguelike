extends Node3D


@onready var subscribers = []

func subscribe(block):
	subscribers.append(block) 
	
func unsubscribe(block): 
	subscribers.erase(block) 


func map_updated(): 
	GameStart.map_updated()
