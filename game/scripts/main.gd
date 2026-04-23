extends Node2D

@onready var pause = $PauseMenu
@onready var player = $Bob
@onready var start_spawn = $CockpitRoom/Start_Spawn


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("room_manager")
	pause.visible = false
	
	#put player at start
	await get_tree().process_frame
	player.global_position = start_spawn.global_position
	
	if player is CharacterBody2D:
		player.velocity = Vector2.ZERO
				
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			get_tree().paused = false
			pause.visible = false
		else:
			get_tree().paused = true
			pause.visible = true
			pause.resume_btn.grab_focus()
					
