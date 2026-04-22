extends Node2D

var shake_strength = 4.0 #camera shake strength
var shake_time = 0.4 #camera shake time
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("crash") #plays scene
	await get_tree().create_timer(8).timeout #at 8 second show explosion
	$Explosion.visible = true
	$Explosion.play()
	shake_camera()
	$Ship.visible = false #hide ship at 8 seconds
	
	
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
func shake_camera(): #function camera shake
	var camera = $Shake_camera
	var duration = shake_time
	
	while duration > 0:
		duration -= get_process_delta_time()
		camera.offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
			
		)
		await get_tree().process_frame
	camera.offset = Vector2.ZERO
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
