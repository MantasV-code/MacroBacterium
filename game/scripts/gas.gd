extends Node2D

@onready var particles = $CPUParticles2D
@onready  var area = $Damagezone

#set gas as false = not on
#var active_gas  = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize() #want to randomize the time frame it appears
	particles.emitting = false
	particles.visible = false
	area.monitoring = false
	_toggle_loop()
	
func _toggle_loop() -> void:
	#while loop to turn gas on (show the particles, the area of damage when it appears)
	while true:
		#active_gas = true
		particles.visible = true
		particles.emitting = true
		area.monitoring = true
		
		#time is on -> x second to y seconds
		await get_tree().create_timer(randf_range(0.1, 2.0)).timeout
		
		#active_gas = false
		particles.emitting = false
		area.monitoring = false
		#0.8 seconds for the animation to end properly
		await get_tree().create_timer(0.8).timeout
		particles.visible = false
		
		#time gas is on
		await get_tree().create_timer(randf_range(0.5, 1.0)).timeout
		
		
