extends CharacterBody2D
const SPEED = 100.0
const TARGET_DISTANCE = 30.0
const HOVER_STRENGTH = 20.0
const SMOOTHING = 0.7  # Higher = more responsive
@onready var deathsound = %Death
@onready var hurtbox = %Hurtbox
@onready var hurtbox2 = %Hurtbox2
var player: Node2D
var bounce_timer := 0.0
var orbit_angle := 0.0  # Track orbit position
var bullet_scene = preload("res://scenes/BOB/Bullet.tscn")
@onready var shoot_timer = %ShootTimer
@onready var sprite = $AnimatedSprite2D
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	sprite.play("Flying")
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	orbit_angle = randf() * TAU  # Random starting orbit position
func decrease_health(amount: int) -> void:
	$Health.decrease_health(amount)
func on_death() -> void:
	set_physics_process(false)
	deathsound.play()
	sprite.play("Death")
	await sprite.animation_finished
	queue_free()
func _physics_process(delta: float) -> void:
	if !player:
		return
	
	# Update bounce timer
	if bounce_timer > 0.0:
		bounce_timer -= delta
	
	var to_player = player.global_position - global_position
	var distance = to_player.length()
	var direction = to_player.normalized()
	var desired_velocity = Vector2.ZERO
	
	var MIN_DISTANCE = TARGET_DISTANCE - 40
	var MAX_DISTANCE = TARGET_DISTANCE + 40
	
	if distance > MAX_DISTANCE:
		# move toward player
		desired_velocity = direction * SPEED
		orbit_angle += delta * 2.0  # Update orbit angle while approaching
		
	elif distance < MIN_DISTANCE:
		# move away
		desired_velocity = -direction * SPEED * 0.7
		orbit_angle += delta * 2.0
		
	else:
		# orbit around the player's CURRENT position
		orbit_angle += delta * 1.5  # Rotate around player
		
		# Calculate ideal orbit position relative to player
		var orbit_offset = Vector2(cos(orbit_angle), sin(orbit_angle)) * TARGET_DISTANCE
		var target_pos = player.global_position + orbit_offset
		
		# Move toward that orbit position
		var to_target = target_pos - global_position
		desired_velocity = to_target.normalized() * SPEED
	
	# Smooth movement
	velocity = velocity.lerp(desired_velocity, SMOOTHING)
	
	# Move + collision
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider == player and bounce_timer <= 0.0:
			var bounce_dir = (global_position - player.global_position).normalized()
			velocity = bounce_dir * 200.0
			bounce_timer = 0.5
		else:
			velocity = velocity.bounce(collision.get_normal()) * 0.8
			
func _on_shoot_timer_timeout() -> void:
	fire_in_four_directions()
func fire_in_four_directions() -> void:
	var directions = [
		Vector2.RIGHT,
		Vector2.LEFT,
		Vector2.UP,
		Vector2.DOWN
	]
	for dir in directions:
		var bullet = bullet_scene.instantiate()
		get_parent().add_child(bullet)
		bullet.global_position = global_position
		bullet.setup(dir, TurretStats, Vector2.ZERO, true)
