extends Area2D

#make sure the mask layer is on layer 2 for the detection
# -- intanlize the room id in inspector --
@export var room_id: String = ""


# -- Player detection for enemies --
func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("player"):
		print("bob detected")
		body.current_room = room_id
		print("bob is in the room: ", body.current_room)# Called when the node enters the scene tree for the first time.
		
		var room = get_parent() # get the parent node
		
		# If the room exists and has enemy and item functions call them
		if room and room.has_method("spawn_enemies"):
			room.call_deferred("spawn_enemies")
		
		if room.has_method("spawn_items"):
			room.call_deferred("spawn_items")
