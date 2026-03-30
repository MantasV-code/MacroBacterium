extends Area2D

@export var damage: int = 1


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("decrease_health"):
		body.decrease_health(damage)
