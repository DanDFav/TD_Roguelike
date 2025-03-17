extends Control


@onready var hbox = $Container/MarginContainer2/HBoxContainer

@onready var unit_controller = $".."

var buttons = []

func _ready() -> void:
	var uniques = []
	for unit in Party.party: 
		if unit not in uniques: 
			var icon_normal = Party.character_dictionary[unit]["Icon_normal"]
			var icon_selected = Party.character_dictionary[unit]["Icon_hover"]
			create_texture_button(unit, icon_normal, icon_selected, count_value(unit, Party.party))
		uniques.append(unit)

func count_value(target, arr):
	var count = 0
	for value in arr:
		if value == target:
			count += 1
	return count

func create_texture_button(unit, normal, selected, max_clicks): 
	var button = TextureButton.new()
	button.texture_normal = normal
	button.texture_hover = selected
	button.texture_pressed = selected
	button.custom_minimum_size = Vector2(100, 100)  
	button.ignore_texture_size = true
	button.toggle_mode = true
	button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	button.connect("pressed", Callable(unit_controller, "unit_selected").bind(unit))
	
	button.set_meta("max_clicks", max_clicks)
	button.set_meta("current_clicks", 0)

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
	var current_clicks = button.get_meta("current_clicks")
	var max_clicks = button.get_meta("max_clicks")
	current_clicks += 1 
	button.set_meta("current_clicks", current_clicks)
	if current_clicks < max_clicks:
		return
	
	unit_controller.remove_unit_from_placeable(unit)
	buttons.erase(button)
	button.queue_free()
