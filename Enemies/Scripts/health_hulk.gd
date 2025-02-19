extends Node3D


@onready var mesh = $"../MeshInstance3D"
@onready var hurt_timer = $Timer

var health = 2000

func on_hit(damage): 
	health -= damage
	print("health: ", health)
	if health <= 0: 
		on_death()

	var on_hover_mat = StandardMaterial3D.new()
	on_hover_mat.albedo_color = Color("e80c0c")
	mesh.material_override = on_hover_mat
	hurt_timer.start()
	

func on_death(): 
	print("killed: ", get_parent())
	get_parent().on_death()


func _on_timer_timeout() -> void:
	var on_hover_mat = StandardMaterial3D.new()
	on_hover_mat.albedo_color = get_parent().colour
	mesh.material_override = on_hover_mat
