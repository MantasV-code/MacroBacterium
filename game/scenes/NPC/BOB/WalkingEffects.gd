extends CPUParticles2D

func _ready() -> void:
	amount = 3
	lifetime = 0.3
	randomness = 1.0
	explosiveness = 0
	emitting = false 
	
	direction = Vector2(0, 1) 
	spread = 40.0
	initial_velocity_min = 10.0
	initial_velocity_max = 30.0
	damping_min = 20.0
	damping_max = 40.0
	gravity = Vector2(0, 0)
	scale_amount_min = 0.2
	scale_amount_max = 0.7
	
	var grad = Gradient.new()
	grad.set_color(0, Color(0.894, 0.835, 0.78, 0.573))  
	grad.set_color(1, Color(1.0, 1.0, 1.0, 0.0))  
	color_ramp = grad
