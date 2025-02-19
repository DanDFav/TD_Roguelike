extends Node3D


@onready var range = $"../range"
@onready var timer = $Timer
@onready var stats = $"../../Stats"

var friendlies_in_range = []
var can_heal = false 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if len(friendlies_in_range) > 0 and timer.is_stopped():
		timer.start()

#   TODO:
#	can do like 
#   if can_heal and friendly_in_range_is_missing_health: 
#   then when no friendly needs healing, it doesnt use a heal until the moment a friendly takes damage
	if can_heal: 
		heal()

func heal(): 
	if len(friendlies_in_range) > 0:
		var health_node = friendlies_in_range[0].get_parent().get_node("health")
		health_node.heal(stats.heal_val)
		print("healing health: ", health_node.health)
		can_heal = false

#func get_friend_with_least_health(): 
	#for i in friendlies_in_range: 
		#


func update_friendlies_in_range(friends): 
	friendlies_in_range = friends


func _on_timer_timeout() -> void:
	can_heal = true
