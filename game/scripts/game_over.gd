extends Control

@onready var retry_btn = $VBoxContainer/RETRY
@onready var quit_btn = $VBoxContainer/QUIT
@onready var cursor = $Cursor
@onready var fade = $ColorRect

var pulse_time = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#game over menu invisible
	$"GAME OVER".visible = false
	$VBoxContainer.visible = false
	cursor.visible = false
	
	fade.modulate.a = 0
	fade_in()
	
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		if retry_btn.has_focus():
			$SelectOptionSound.play()
			await get_tree().create_timer(1.0).timeout
			#test room for testing, change where the user will start
			get_tree().change_scene_to_file("res://scenes/rooms/test_room.tscn")
		
		elif quit_btn.has_focus():
			get_tree().quit() 
			
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
		$CusorMoveSound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pulse_time += delta
	var pulse = 0.75 + 0.25 * sin(pulse_time * 4)
	
	retry_btn.modulate = Color(1,1,1)
	quit_btn.modulate = Color(1,1,1)
	
	if retry_btn.has_focus():
		cursor.global_position = retry_btn.global_position + Vector2(-65, 0)
		retry_btn.modulate = Color(0, pulse, 0)
	
	elif quit_btn.has_focus():
		cursor.global_position = quit_btn.global_position + Vector2(-65, 0)
		quit_btn.modulate = Color(0, pulse, 0)

func _on_retry_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	pass # Replace with function body.
	
func fade_in():
	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 0.7, 1.0) #fade to black over a second
	#after fading show game over menu
	await tween.finished
	show_menu()
	
func show_menu():
	$"GAME OVER".visible = true
	$VBoxContainer.visible = true
	cursor.visible = true
	
	retry_btn.grab_focus()
