extends CharacterBody2D

const SPEED = 60.0
const BOUNCE_STRENGTH = 200.0
const LAZY_FACTOR = 0.02

var player: Node2D
var bounce_timer := 0.0
var wander_offset := Vector2.ZERO
var wander_timer := 0.0
var wander_change_time := 0.0  # how long until next wander direction

@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	sprite.play("Flying")
	# Each fly starts with a different random phase
	wander_change_time = randf_range(1.0, 3.0)

func _physics_process(delta: float) -> void:
	bounce_timer -= delta
	wander_timer += delta
	
	# Periodically pick a new random wander direction
	if wander_timer >= wander_change_time:
		wander_timer = 0.0
		wander_change_time = randf_range(1.0, 3.0)
		wander_offset = Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		).normalized() * SPEED * 0.6  # wander at 60% of main speed

	if !player:
		return

	var desired = (player.global_position - global_position).normalized() * SPEED
	# Mix player direction with random wander
	velocity = velocity.lerp(desired + wander_offset, LAZY_FACTOR)
	
	# Wobble
	velocity.y += sin(Time.get_ticks_msec() * 0.005) * 2.0

	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider == player and bounce_timer <= 0.0:
			var bounce_dir = (global_position - player.global_position).normalized()
			velocity = bounce_dir * BOUNCE_STRENGTH
			bounce_timer = 0.5
		else:
			velocity = velocity.bounce(collision.get_normal()) * 0.8
