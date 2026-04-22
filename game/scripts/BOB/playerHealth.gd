extends Node

@export var max_health: int = 3
var current_health: int = 3


func _ready() -> void:
	update_hud()


# increase health 
func increase_health(amount: int) -> void:
	if current_health < max_health:
		current_health += amount
		print("Bob's Health: ", current_health )
	else:
		print("Bob has full health")
	update_hud()

# increase max health
func increase_max_health(amount: int) -> void:
	max_health += amount
	print("Bob's Max Health: ", max_health)

# decrease health
func decrease_health(amount: int) -> void:
	current_health -= amount
	print(get_parent().name, " health:", current_health)
	
	# trigger death if health is gone
	if current_health <= 0:
		die()
	update_hud()

# Handels death
func die() -> void:
	print(get_parent().name, " died")
	if get_parent().has_method("on_death"):
		get_parent().on_death()
	else:
		get_parent().queue_free()

# update the HUD (current health)
func update_hud() -> void:
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.update_current_health_label(current_health)
		hud.update_health_icon(current_health, max_health)
	
