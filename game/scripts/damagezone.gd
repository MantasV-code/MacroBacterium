extends Area2D

@export var damage: int = 1

# called when player enters damage area
func _on_body_entered(body: Node2D) -> void:
	# check if the object can take damage (has the method to do so)
	if body.has_method("decrease_health"):
		body.decrease_health(damage) # decrease the health by 1
