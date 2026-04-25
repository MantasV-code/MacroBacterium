extends Area2D

#make sure the mask layer is on layer 2 for the detection
# -- intanlize the room id in inspector --
@export var room_id: String = ""


# -- Player detection for enemies --
func _on_body_entered(body: Node2D) -> void:
	print("bob detected")
	if body.is_in_group("player"):
		body.current_room = room_id
		print("bob is in the room", body.current_room)# Called when the node enters the scene tree for the first time.
