extends Control


@onready var hbox = $Container/MarginContainer2/HBoxContainer

@onready var unit_controller = $".."

var buttons = []

func _ready() -> void:
	for unit in Party.party: 
		var icon_normal = Party.character_dictionary[unit]["Icon_normal"]
		var icon_selected = Party.character_dictionary[unit]["Icon_hover"]
		create_texture_button(unit, icon_normal, icon_selected)
	
	#var uniques = []
	#for unit in Party.util_party:
		#if unit not in uniques: 
			#var icon_normal = Party.character_dictionary[unit]["Icon_normal"]
			#var icon_selected = Party.character_dictionary[unit]["Icon_hover"]
			#create_texture_button(unit, icon_normal, icon_selected)
			#uniques.append(unit) 



func create_texture_button(unit, normal, selected): 
	var button = TextureButton.new()
	button.texture_normal = normal
	button.texture_hover = selected
	button.texture_pressed = selected
	button.custom_minimum_size = Vector2(100, 100)  
	button.ignore_texture_size = true
	button.toggle_mode = true
	button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	
	button.connect("pressed", Callable(unit_controller, "unit_selected").bind(unit))
	
	Party.character_dictionary[unit]["Icon"] = button
	buttons.append(button)
	hbox.add_child(button) 



## TODO: BUTTON BUG: When the roadblocks are created, the button reference is stored
## in the party dictionary, when there are 3 roadblock buttons, only one reference is 
## stored in the dictionary 
func unit_selected(unit): 
	var button = Party.character_dictionary[unit]["Icon"]
	
	button.button_pressed = true
	for i in buttons: 
		if i != button: 
			i.button_pressed = false

func deselect_buttons(): 
	for i in buttons: 
		i.button_pressed = false

func remove_button(unit, party_left): 
	var button = Party.character_dictionary[unit]["Icon"]
	if unit in party_left: 
		print("STILL HERE!")
	buttons.erase(button)
	button.queue_free()
