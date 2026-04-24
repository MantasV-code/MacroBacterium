extends Node2D

@onready var pause = $PauseMenu
@onready var player = $Bob
@onready var start_spawn = $CockpitRoom/Start_Spawn
@onready var camera = $Bob/BOB/Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("room_manager")
	pause.visible = false
	set_camera_limits($CockpitRoom)
	
	#put player at start
	await get_tree().process_frame
	player.global_position = start_spawn.global_position
	
	if player is CharacterBody2D:
		player.velocity = Vector2.ZERO
				
# -- PAUSE MENU --
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			get_tree().paused = false
			pause.visible = false
		else:
			get_tree().paused = true
			pause.visible = true
			pause.resume_btn.grab_focus()
			
#-- CAMERA LIMIT --
func set_camera_limits(room: Node2D) -> void:
	var top_left := room.get_node_or_null("CameraTopLeft") as Marker2D
	var bottom_right := room.get_node_or_null("CameraBottomRight") as Marker2D
	
	if top_left == null or bottom_right == null:
		print("missing camera marker", room.name)
		return
		
	camera.limit_left = int(top_left.global_position.x)
	camera.limit_top = int(top_left.global_position.y)
	camera.limit_right = int(bottom_right.global_position.x)
	camera.limit_bottom = int(bottom_right.global_position.y)
					
