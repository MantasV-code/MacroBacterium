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
@export var damage: int = 1
@export var piercing: bool = false
@export var count: int = 1         
@export var spread: float = 0.0    
@export var color: Color = Color.SKY_BLUE
@export var scale_multiplier: float = 1
@export var lifetime: float = 20.0
@export var shoot_speed: float = 1

func apply_effect(upgrade_name: String) -> void:
	match upgrade_name:
		"Max_health_up":
			Max_health += 1 # Update the global 'Master' variable
			var player = get_tree().get_first_node_in_group("player")
			if player:
				player.increase_health(1) 
				print("Bob's health increased. Global health is now: ", health)	
		"health_up":
			health += 1 # Update the global 'Master' variable
			var player = get_tree().get_first_node_in_group("player")
			if player:
				player.increase_health(1) 
				print("Bob's health increased. Global health is now: ", health)
		"double_shot":
			count += 1
			spread += 15.0
		"triple_shot":
			count += 2
			spread += 20.0
		"piercing":
			piercing = true
			color = Color.YELLOW
		"Power":
			color = Color.RED
			damage += 0.5
		"fast":
			speed = 1400.0
			SPEED = 350.0
