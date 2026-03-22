extends Area2D
@export var health: int = 1

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("increase_health"):
		body.increase_health(health)
	queue_free()
