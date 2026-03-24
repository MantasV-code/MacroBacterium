extends GPUParticles2D

func _ready() -> void:
	amount = 20
	lifetime = 1.5
	randomness = 4.0
	
	var mat = ParticleProcessMaterial.new()
	
	mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	mat.emission_sphere_radius = 6.0
	mat.spread = 180.0
	mat.initial_velocity_min = 5.0
	mat.initial_velocity_max = 20.0
	mat.damping_min = 10.0
	mat.damping_max = 20.0
	mat.gravity = Vector3(0, 15, 0)
	mat.scale_min = 1.5
	mat.scale_max = 2.0
	
	# Simple green fade out
	var grad = Gradient.new()
	grad.set_color(0, Color(0.322, 0.024, 0.043, 1.0))  
	grad.set_color(1, Color(0.922, 0.0, 0.17, 0.0))  
	var grad_tex = GradientTexture1D.new()
	grad_tex.gradient = grad
	mat.color_ramp = grad_tex
	
	process_material = mat
