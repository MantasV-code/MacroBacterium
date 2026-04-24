extends Node2D


@onready var camera = get_tree().current_scene.get_node("Bob/BOB/Camera2D")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 5.0
	#set camera limit
	set_camera_limits_markers($CameraTopLeft_A, $CameraBottomRight_A)
	
	var _camera_tween: Tween

#-- Signal when enter the threshold
func _on_boss_threshold_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		camera.position_smoothing_enabled = true
		camera.position_smoothing_speed = 2.0
		set_camera_limits_markers($CameraTopLeft_B, $CameraBottomRight_B)
		

#-- setting camera limits --
func set_camera_limits_markers(top_left: Marker2D, bottom_right: Marker2D) -> void:
	camera.limit_left = int(top_left.global_position.x)
	camera.limit_top = int(top_left.global_position.y)
	camera.limit_right = int(bottom_right.global_position.x)
	camera.limit_bottom = int(bottom_right.global_position.y)
