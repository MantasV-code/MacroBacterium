extends Area2D

# -- initalize room id as boss_room --
@export var room_id: String = "boss_room"


# -- Player detection for enemies --
func _on_body_entered(body: Node2D) -> void:
	print("bob detected")
	if body.is_in_group("player"):
		body.current_room = room_id
		print("bob is in the room", body.current_room)
