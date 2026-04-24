extends Node2D
@onready var camera = $Bob/BOB/Camera2D



# Called when the node enters the scene tree for the first time.
func _ready():
	print("Looking for:", Global.next_spawn)
	print("Children:", get_children())
	set_camera_limits("res://scenes/rooms/test_room_2.tscn")
	
	if Global.next_spawn != "":
		if has_node(Global.next_spawn):
			print("FOUND SPAWN")
			var spawn = get_node(Global.next_spawn)
			$Bob.global_position = spawn.global_position
		else:
			print("Spawn NOT found")
			
func set_camera_limits(room: Node2D) -> void:
	var top_left := room.get_node_or_null("CameraTopLeft") as Marker2D
	var bottom_right := room.get_node_or_null("CameraBottomRight") as Marker2D
	
	if top_left == null or bottom_right == null:
		print("missing camera marker", room.name)
		return
		
	camera.limit_left = int(top_left.global_position.x)
	camera.limit_top = int(top_left.global_position.y)
	camera.limit_right = int(bottom_right.global_position.x)
	camera.limit_ = int(bottom_right.global_position.y)
