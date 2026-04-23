extends CharacterBody2D

# All stats now come from the Autoload 'PlayerData'
@onready var head = %head
@onready var Body = %Body
@onready var SFX1 = %Shoot
@onready var FaceHole = %FaceHole
@onready var SFX2 = %Walking
@onready var Deathsound = %Death
@onready var walk_particles = %WalkParticles
var is_dead

var bullet_scene = preload("res://scenes/BOB/Bullet.tscn")
var is_shooting = false

func _ready() -> void:
	# Initialize health from PlayerData
	$Health.max_health = BobStats.health
	$Health.current_health = BobStats.health
	
	head.sprite_frames.set_animation_loop("ShootF", false)
	head.sprite_frames.set_animation_loop("ShootB", false)
	head.sprite_frames.set_animation_loop("ShootLR", false)

func increase_health(amount: int) -> void:
	$Health.increase_health(amount)

func decrease_health(amount: int) -> void:
	$Health.decrease_health(amount)

func on_death() -> void:
	if is_dead:
		return
	is_dead = true
	head.visible = false	
	Body.play("Death")
	Deathsound.play()
	await Body.animation_finished
	await get_tree().create_timer(0.5).timeout
	head.visible = false	
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	queue_free()

func _physics_process(delta: float) -> void:
	if is_dead:
		return
		
	var move_direction := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	
	var aim_direction := Vector2(
		Input.get_axis("aim_left", "aim_right"),
		Input.get_axis("aim_up", "aim_down")
	).normalized()

	if aim_direction != Vector2.ZERO and !is_shooting:
		shoot(aim_direction)

	if move_direction != Vector2.ZERO:
		velocity = velocity.move_toward(move_direction * BobStats.SPEED, BobStats.ACCELERATION * delta)
		_update_body(move_direction, true)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, BobStats.FRICTION * delta)
		_update_body(Vector2.ZERO, false)

	if is_shooting and aim_direction != Vector2.ZERO:
		_update_shoot_head(aim_direction)
	elif !is_shooting:
		_update_idle_head(move_direction)

	move_and_slide()

# Returns the shoot animation name based on shoot direction
func _get_shoot_anim(direction: Vector2) -> String:
	if abs(direction.y) > abs(direction.x):
		return "ShootF" if direction.y < 0 else "ShootB"
	else:
		return "ShootLR"

# Updates head animation while shooting, preserving the correct frame if animation changes
func _update_shoot_head(direction: Vector2) -> void:
	var target_anim = _get_shoot_anim(direction)
	if head.animation != target_anim:
		var current_frame = head.frame
		head.sprite_frames.set_animation_loop(target_anim, false)
		head.play(target_anim, BobStats.shoot_speed)
		head.frame = current_frame
	if target_anim == "ShootLR":
		head.scale.x = -1 if direction.x < 0 else 1

# Updates head animation when not shooting
func _update_idle_head(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		head.play("IdleF")
		return
	if abs(direction.y) > abs(direction.x):
		head.play("IdleB" if direction.y < 0 else "IdleF")
	else:
		head.play("IdleLR")
		head.scale.x = -1 if direction.x < 0 else 1

# Plays shoot animation, spawns bullet, waits for animation to finish
func shoot(direction: Vector2) -> void:
	is_shooting = true
	SFX1.play()
	
	var anim = _get_shoot_anim(direction)
	head.play(anim, BobStats.shoot_speed) 
	_spawn_bullets(direction)
	await head.animation_finished
	is_shooting = false

# Updates animation and effects based on movement
func _update_body(direction: Vector2, is_moving: bool) -> void:
	if is_dead:
		return
	if !is_moving:
		Body.play("IdleF")
		Body.scale.x = 1
		if walk_particles:
			walk_particles.emitting = false
		if SFX2.playing:
			SFX2.stop()
		return

	# Pick directional walk animation
	if abs(direction.y) > abs(direction.x):
		if direction.y < 0:
			Body.play("WalkB")
			Body.scale.x = -1
		else:
			Body.play("WalkF")
			Body.scale.x = 1
	else:
		Body.play("WalkLR")
		Body.scale.x = -1 if direction.x < 0 else 1

	if walk_particles:
		walk_particles.emitting = true
	if !SFX2.playing:
		SFX2.play()

func _spawn_bullets(direction: Vector2) -> void:
	var p_count = BobStats.count
	var p_spread = deg_to_rad(BobStats.spread)

	for i in p_count:
		var angle_offset = 0.0
		if p_count > 1:
			angle_offset = lerp(-p_spread / 2.0, p_spread / 2.0, float(i) / float(p_count - 1))

		var bullet_dir = direction.rotated(angle_offset)
		var bullet = bullet_scene.instantiate()
		
		# ADD TO SCENE FIRST
		get_parent().add_child(bullet)
		bullet.global_position = FaceHole.global_position
		
		# SETUP SECOND (Pass BobStats itself)
		bullet.setup(bullet_dir, BobStats, velocity * 1.4, false)
