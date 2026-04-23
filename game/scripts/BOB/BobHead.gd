extends AnimatedSprite2D

var base_y: float
var bob_speed := 1.0
var bob_amount := 1.0
var time := 0.0
const FPS := 8.0

func _ready() -> void:
	base_y = position.y

func _process(delta: float) -> void:
	time += delta
	var stepped_time = floor(time * FPS) / FPS
	position.y = base_y + sin(stepped_time * bob_speed * TAU) * bob_amount

#This is just a basic script to aniamte bobs head
