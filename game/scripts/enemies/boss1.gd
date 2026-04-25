extends CharacterBody2D

const ORBIT_SPEED = 2.0  # Radians per second for orbit
const ORBIT_DISTANCE = 200.0
const DASH_SPEED = 600.0
const DASH_COOLDOWN = 4.0  # Seconds between dashes
const DASH_DURATION = 0.2  # How long the dash lasts
const RETURN_SPEED = 150.0  # Speed to return to orbit after dash

@onready var deathsound = %Death
@onready var Shootsound = $Shoot
@onready var hurtbox = %Hurtbox
@onready var hurtbox2 = %Hurtbox2
@onready var shoot_timer = %ShootTimer
@onready var sprite = $AnimatedSprite2D

#setting enemy id for room
@export var enemy_room: String 

var player: Node2D
var bullet_scene = preload("res://scenes/BOB/Bullet.tscn")
var is_dead = false

# State management
enum State { ORBITING, DASHING, RETURNING }
var current_state = State.ORBITING

# Orbit tracking
var orbit_angle := 0.0

# Dash tracking
var dash_timer := 0.0
var dash_direction := Vector2.ZERO
var dash_elapsed := 0.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	sprite.play("Flying")
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	orbit_angle = randf() * TAU  # Random starting position
	dash_timer = DASH_COOLDOWN  # Start with full cooldown

func decrease_health(amount: int) -> void:
	$Health.decrease_health(amount)

func on_death() -> void:
	is_dead = true
	shoot_timer.stop()
	hurtbox.disabled = true
	hurtbox2.disabled = true
	deathsound.play()
	#sprite.play("Death")
	#await sprite.animation_finished
	
	
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/game_complete.tscn")
	queue_free()

func _physics_process(delta: float) -> void:
	if !player or is_dead:
		return
	
	#stop boss unless bob is in the same room
	if player.current_room != enemy_room:
		velocity = Vector2.ZERO
		return
		
	match current_state:
		State.ORBITING:
			handle_orbiting(delta)
		State.DASHING:
			handle_dashing(delta)
		State.RETURNING:
			handle_returning(delta)
	
	move_and_slide()

func handle_orbiting(delta: float) -> void:
	# Update orbit angle
	orbit_angle += ORBIT_SPEED * delta
	if orbit_angle > TAU:
		orbit_angle -= TAU
	
	# Calculate target orbit position
	var orbit_offset = Vector2(cos(orbit_angle), sin(orbit_angle)) * ORBIT_DISTANCE
	var target_pos = player.global_position + orbit_offset
	
	# Move smoothly toward orbit position
	var direction = (target_pos - global_position).normalized()
	velocity = direction * 150.0  # Movement speed while orbiting
	
	# Check if ready to dash
	dash_timer -= delta
	if dash_timer <= 0.0:
		start_dash()

func handle_dashing(delta: float) -> void:
	# Dash straight toward where player was when dash started
	velocity = dash_direction * DASH_SPEED
	
	dash_elapsed += delta
	if dash_elapsed >= DASH_DURATION:
		current_state = State.RETURNING
		dash_elapsed = 0.0

func handle_returning(delta: float) -> void:
	# Return to orbit position
	var orbit_offset = Vector2(cos(orbit_angle), sin(orbit_angle)) * ORBIT_DISTANCE
	var target_pos = player.global_position + orbit_offset
	var direction = (target_pos - global_position).normalized()
	
	velocity = direction * RETURN_SPEED
	
	# Check if close enough to orbit position
	var distance = global_position.distance_to(target_pos)
	if distance < 50.0:
		current_state = State.ORBITING
		dash_timer = DASH_COOLDOWN  # Reset dash cooldown

func start_dash() -> void:
	current_state = State.DASHING
	dash_direction = (player.global_position - global_position).normalized()
	dash_elapsed = 0.0

func _on_shoot_timer_timeout() -> void:
	if player and not is_dead and current_state == State.ORBITING:
		if player.current_room == enemy_room:
			fire_at_player()
		

func fire_at_player() -> void:
	var direction = (player.global_position - global_position).normalized()
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = global_position
	bullet.setup(direction, Boss1Stats, Vector2.ZERO, true)
