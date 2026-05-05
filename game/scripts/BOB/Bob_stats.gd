extends Node

# --- Bob's Physical Stats ---
@export_group("Movement")
@export var SPEED = 200.0
@export var ACCELERATION = 800.0
@export var FRICTION = 2800.0
@export var health = 3
@export var Max_health = 3


# --- Projectile Stats ---
@export_group("Projectiles")
@export var speed: float = 100.0
@export var damage: float = 1
@export var piercing: bool = false
@export var count: int = 1         
@export var spread: float = 0.0    
@export var color: Color = Color.SKY_BLUE
@export var scale_multiplier: float = 1
@export var lifetime: float = 20.0
@export var shoot_speed: float = 1

func modify_health(item_effect: String, value: int) -> void:
	match item_effect:
		"increase_health":
			var player = get_tree().get_first_node_in_group("player")
			if player:
				player.increase_health(value) 
		"increase_max_health":
			var player = get_tree().get_first_node_in_group("player")
			if player:
				player.increase_max_health(value) 
			
func apply_effect(item_effect: String) -> void:
	match item_effect:
		"double_shot":
			count += 1
			spread += 15.0
		"triple_shot":
			count += 2
			spread += 20.0
		"piercing":
			piercing = true
			color = Color.YELLOW
		"power":
			color = Color.RED
			damage += 1
		"speed":
			SPEED += 50.0
