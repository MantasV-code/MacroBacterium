extends CanvasLayer

@onready var resume_btn = $Panel/Resume_btn
@onready var quit_btn = $Panel/Quit_btn
@onready var cursor = $Cursor

var pulse_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	resume_btn.grab_focus() #resume btn is default selection
	
func resume(): #function to resume
	get_tree().paused = false
	visible = false
	
func quit(): #function to quit
	get_tree().quit()
	
func _input(event): #event function for the cursor when the user uses keys to navigate menu
	if !visible:
		return
		
	if event.is_action_pressed("ui_accept"):
		$SelectOptionSound.play()
		if resume_btn.has_focus():
			resume()
		
		elif quit_btn.has_focus():
			quit()
	
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
		$CusorMoveSound.play()
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !visible:
		return
		
	pulse_time += delta
	var pulse = 0.75 + 0.25 * sin(pulse_time * 4) #pulsing time
	
	#Reset
	resume_btn.modulate = Color(1,1,1) #reset btns to white when cusor isnt on it
	quit_btn.modulate = Color(1,1,1)
	
	if resume_btn.has_focus():
		cursor.global_position = resume_btn.global_position + Vector2(-65, 0)
		resume_btn.modulate = Color(0, pulse, 0) #pulse green
		
	elif quit_btn.has_focus():
		cursor.global_position = quit_btn.global_position + Vector2(-65, 0)
		quit_btn.modulate = Color(0, pulse, 0)


func _on_resume_btn_pressed() -> void:
	resume()


func _on_quit_btn_pressed() -> void:
	quit()
