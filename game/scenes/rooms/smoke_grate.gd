extends CPUParticles2D

func _ready() -> void:
	var grad = Gradient.new()
	grad.set_color(0, Color(0.8, 0.8, 0.8, 1.0))
	grad.set_color(1, Color(0.8, 0.8, 0.8, 0.0))
	color_ramp = grad
	
	var curve = Curve.new()
	curve.add_point(Vector2(0.0, 1.0))
	curve.add_point(Vector2(1.0, 0.0))
	scale_amount_curve = curve
