extends Control

@onready var start_btn = $VBoxContainer/StartButton
@onready var quit_btn = $VBoxContainer/QuitButton
@onready var cursor = $Cursor

var pulse_tim = 0.0

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if start_btn.has_focus():
			$SelectOptionSound.play() #if user press enter 
			await get_tree().create_timer(1.0).timeout #wait 1 second then switch to next scene
			get_tree().change_scene_to_file("res://scenes/intro/space_flight.tscn")
	
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
		$CusorMoveSound.play() #if user goes through options

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_btn.grab_focus() #have the focus and cusor start on start btn
	
	$Music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pulse_tim += delta
	var pulse = 0.75 + 0.25 * sin(pulse_tim * 4) #pulsing time
	
	#Reset
	start_btn.modulate = Color(1,1,1) #reset btns to white when cusor isnt on it
	quit_btn.modulate = Color(1,1,1)
	
	if start_btn.has_focus():
		cursor.global_position = start_btn.global_position + Vector2(-65, 0)
		start_btn.modulate = Color(0, pulse, 0) #pulse green
		
	elif quit_btn.has_focus():
		cursor.global_position = quit_btn.global_position + Vector2(-65, 0)
		quit_btn.modulate = Color(0, pulse, 0)
	
	
#func _on_start_button_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/intro/space_flight.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit() #game closes if user picks "quit"
