extends Node3D


@onready var max_health = 2000
@onready var health = max_health


func heal(value): 
	health = health + value
	if health > max_health: 
		health = max_health
		

func take_damage(damage): 
	health -= damage
	print(health)
