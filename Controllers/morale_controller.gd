extends Node3D

var morale : int
@onready var spec_stage_script = $"../Specific_stage_scrp"
@onready var label = $display_morale_l
@onready var morale_timer = $morale_timer

var start = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame  # Ensures nodes are ready
	if spec_stage_script:
		morale = spec_stage_script.starting_morale
		label.text = str(morale)
		morale_timer.start()
		start = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start: 
		label.text = str(morale)


func _on_morale_timer_timeout() -> void:
	morale += 1
	

func get_morale() -> int:
	return morale

func spend_morale(cost : int):
	morale -= cost  

func increase_morale(increase : int):
	print("Before: ", morale)
	morale += increase
	print("After: ", morale)
	
