extends Node3D


@onready var range = $"../range_n3D"
@onready var timer = $Timer
@onready var stats = $"../../stats_n3D"

var friendlies_in_range = []
var can_heal = false 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if len(friendlies_in_range) > 0 and timer.is_stopped():
		timer.start()

#   TODO:
#	can do like 
#   if can_heal and friendly_in_range_is_missing_health: 
#   then when no friendly needs healing, it doesnt use a heal until the moment a friendly takes damage
	var lowest_health = get_friend_with_least_health()
	if can_heal and lowest_health != null: 
		heal(lowest_health)

func heal(to_heal): 
	var health_node = to_heal
	health_node.heal(stats.heal_val)
	can_heal = false

func get_friend_with_least_health(): 
	if len(friendlies_in_range) > 0: 
		var lowest_percent = [100, null]  # [health percentage, unit]

		for unit in friendlies_in_range: 
			var cur_health = unit.health
			var max_health = unit.max_health
			var percent_health = float(cur_health) / float(max_health) * 100
			
			if lowest_percent[0] > percent_health: 
				lowest_percent = [percent_health, unit]  
		
		if lowest_percent[1] == null: 
			return null
		else: 
			return lowest_percent[1]  
	else: 
		return null

func update_friendlies_in_range(friends): 
	for friend in friends: 
		var friend_h_node = friend.get_parent().get_node("health_n3D")
		
		if friend_h_node not in friendlies_in_range: 
			friendlies_in_range.append(friend_h_node)
	
	print(friendlies_in_range)


func _on_timer_timeout() -> void:
	can_heal = true
