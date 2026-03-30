extends Node

@export var max_health: int = 3
var current_health: int

func _ready() -> void:
	current_health = max_health

#decrease bobs health	
func decrease_health(amount: int) -> void:
	current_health -= amount
	print("Bob's Health: ", current_health)
	
	if current_health <= 0:
		die()

# increase bobs health 
func increase_health(amount: int) -> void:
	if current_health < max_health:
		current_health += amount
		print("Bob's Health: ", current_health )
	else:
		print("Bob has full health")
	
# remove bob from the game
func die() -> void:
	print("Player died")
	get_parent().queue_free()
