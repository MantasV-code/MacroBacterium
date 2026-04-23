extends Control
class_name HUD

@export var health_label : Label
@onready var health_texture = $HealthTexture

var normal_texture = preload("res://assets/sprites/pick-ups/HUD_O2 canister.png")
var full_texture = preload("res://assets/sprites/pick-ups/HUD_Golden_O2_canister.png")

# update the current health text for the HUD
func update_current_health_label(number : int):
	health_label.text = "x" + str(number)

# change the health icon based on the players health
func update_health_icon(current_health : int, max_health: int):
	if current_health >= max_health:
		health_texture.texture = full_texture
		health_label.label_settings.font_color = Color.GOLD
	else:
		health_texture.texture = normal_texture
		health_label.label_settings.font_color = Color.WHITE
