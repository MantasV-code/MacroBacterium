extends Node

@export var max_health: int = 3
var current_health: int

func _ready() -> void:
	current_health = max_health

# increase health 
func increase_health(amount: int) -> void:
	if current_health < max_health:
		current_health += amount
		print("Bob's Health: ", current_health )
	else:
		print("Bob has full health")

# decrease health
func decrease_health(amount: int) -> void:
	current_health -= amount
	print(get_parent().name, " health:", current_health)
	
	# trigger death if health is gone
	if current_health <= 0:
		die()

# Handels death
func die() -> void:
	print(get_parent().name, " died")
	if get_parent().has_method("on_death"):
		get_parent().on_death()
	else:
		get_parent().queue_free()
