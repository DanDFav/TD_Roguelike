extends Control


var vanguard_enabled := true
var ranger_enabled := true
var healer_enabled := true
var scout_enabled := true
var style_enabled = StyleBoxFlat.new()
var style_disabled = StyleBoxFlat.new()


func _ready() -> void:
	style_enabled.bg_color = Color("2ebf35")
	style_disabled.bg_color = Color("ff3636")
	$VBoxContainer/vanguard_btn.add_theme_stylebox_override("normal", style_enabled) 
	$VBoxContainer/ranger_btn.add_theme_stylebox_override("normal", style_enabled) 
	$VBoxContainer/healer_btn.add_theme_stylebox_override("normal", style_enabled) 
	$VBoxContainer/scout_btn.add_theme_stylebox_override("normal", style_enabled) 

func _on_vanguard_btn_pressed() -> void:
	
	vanguard_enabled = not vanguard_enabled
	if vanguard_enabled: 
		$VBoxContainer/vanguard_btn.add_theme_stylebox_override("normal", style_enabled) 
		Party.add_to_party(preload("res://Units/Scenes/ground_unit.tscn"))
	else: 
		$VBoxContainer/vanguard_btn.add_theme_stylebox_override("normal", style_disabled)
		Party.remove_from_party(preload("res://Units/Scenes/ground_unit.tscn"))

func _on_ranger_btn_button_down() -> void:
	ranger_enabled = not ranger_enabled 
	if ranger_enabled: 
		$VBoxContainer/ranger_btn.add_theme_stylebox_override("normal", style_enabled)
		Party.add_to_party(preload("res://Units/Scenes/ranged_unit.tscn"))
	else: 
		$VBoxContainer/ranger_btn.add_theme_stylebox_override("normal", style_disabled)
		Party.remove_from_party(preload("res://Units/Scenes/ranged_unit.tscn"))


func _on_healer_btn_pressed() -> void:
	healer_enabled = not healer_enabled
	if healer_enabled: 
		$VBoxContainer/healer_btn.add_theme_stylebox_override("normal", style_enabled) 
		Party.add_to_party(preload("res://Units/Scenes/healer_unit.tscn"))
	else: 
		$VBoxContainer/healer_btn.add_theme_stylebox_override("normal", style_disabled)
		Party.remove_from_party(preload("res://Units/Scenes/healer_unit.tscn"))


func _on_scout_btn_pressed() -> void:
	scout_enabled = not scout_enabled
	if scout_enabled: 
		$VBoxContainer/scout_btn.add_theme_stylebox_override("normal", style_enabled) 
		Party.add_to_party(preload("res://Units/Scenes/scout.tscn"))
	else: 
		$VBoxContainer/scout_btn.add_theme_stylebox_override("normal", style_disabled)
		Party.remove_from_party(preload("res://Units/Scenes/scout.tscn"))


func _on_back_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/Scenes/menu.tscn")
