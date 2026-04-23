extends CharacterBody2D

@onready var head = %head
@onready var Body = %Body
@onready var SFX1 = %Shoot
@onready var FaceHole = %FaceHole
@onready var SFX2 = %Walking
@onready var Deathsound = %Death
@onready var walk_particles = %WalkParticles

# preload the bullet scene for instantiation
var bullet_scene = preload("res://scenes/BOB/Bullet.tscn")
var is_shooting = false
var is_dead = false

#=================================================================
#================== INITIALIZATION ===============================
#=================================================================

func _ready() -> void:
	# sync health component with player stats from autoload
	$Health.max_health = BobStats.health
	$Health.current_health = BobStats.health
	
	# disable looping for all shoot animations so they play once
	for anim in ["ShootF", "ShootB", "ShootLR"]:
		head.sprite_frames.set_animation_loop(anim, false)

#=================================================================
#================= HEALTH MANAGEMENT =============================
#=================================================================

func increase_health(amount: int) -> void:
	$Health.increase_health(amount)
	
func increase_max_health(amount: int) -> void:
	$Health.increase_max_health(amount)

func decrease_health(amount: int) -> void:
	$Health.decrease_health(amount)

func on_death() -> void:
	# prevent running death sequence multiple times
	if is_dead:
		return
	$CollisionShape2D.set_deferred("disabled", true) # disable detection and collision to prevent interactions
	is_dead = true
	head.visible = false	
	Body.play("Death")
	Deathsound.play()
	# wait for death animation to complete
	await Body.animation_finished
	# small pause before transitioning
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	queue_free()

#=================================================================
#================= MAIN UPDATE LOOP ==============================
#=================================================================

# runs every physics frame (default 60 fps)
func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	# get normalized directional input from mapped actions
	var move_direction := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	
	var aim_direction := Vector2(
		Input.get_axis("aim_left", "aim_right"),
		Input.get_axis("aim_up", "aim_down")
	).normalized()

	_handle_shooting(aim_direction)
	_handle_movement(move_direction, delta)
	_handle_animations(move_direction, aim_direction)
	
	# apply velocity to character position
	move_and_slide()

func _handle_shooting(aim_direction: Vector2) -> void:
	# only start shooting if aiming and not already shooting
	if aim_direction != Vector2.ZERO and !is_shooting:
		shoot(aim_direction)

func _handle_movement(move_direction: Vector2, delta: float) -> void:
	if move_direction != Vector2.ZERO:
		# smoothly accelerate towards target speed
		velocity = velocity.move_toward(move_direction * BobStats.SPEED, BobStats.ACCELERATION * delta)
		_update_body_animation(move_direction, true)
	else:
		# smoothly decelerate to a stop
		velocity = velocity.move_toward(Vector2.ZERO, BobStats.FRICTION * delta)
		_update_body_animation(Vector2.ZERO, false)

func _handle_animations(move_direction: Vector2, aim_direction: Vector2) -> void:
	# prioritize shoot animations while shooting
	if is_shooting and aim_direction != Vector2.ZERO:
		_update_shoot_head(aim_direction)
	elif !is_shooting:
		_update_idle_head(move_direction)

#=================================================================
#================== SHOOTING MECHANICS ===========================
#=================================================================

func shoot(direction: Vector2) -> void:
	is_shooting = true
	SFX1.play()
	
	var anim = _get_shoot_anim(direction)
	head.play(anim, BobStats.shoot_speed) 
	_spawn_bullets(direction)
	# wait for animation to finish before allowing next shot
	await head.animation_finished
	is_shooting = false

func _spawn_bullets(direction: Vector2) -> void:
	var p_count = BobStats.count
	var p_spread = deg_to_rad(BobStats.spread)

	for i in p_count:
		var angle_offset = 0.0
		# distribute bullets evenly across the spread angle
		if p_count > 1:
			# lerp from negative half spread to positive half spread
			angle_offset = lerp(-p_spread / 2.0, p_spread / 2.0, float(i) / float(p_count - 1))

		# rotate base direction by calculated offset
		var bullet_dir = direction.rotated(angle_offset)
		var bullet = bullet_scene.instantiate()
		
		# add bullet to scene tree (parent's parent)
		get_parent().add_child(bullet)
		bullet.global_position = FaceHole.global_position
		# pass player velocity for inherited momentum
		bullet.setup(bullet_dir, BobStats, velocity * 1.4, false)

#=================================================================
#================== ANIMATION HELPERS ============================
#=================================================================

# returns correct shoot animation based on direction
func _get_shoot_anim(direction: Vector2) -> String:
	# vertical movement takes priority over horizontal
	if abs(direction.y) > abs(direction.x):
		# negative y is up in godot's coordinate system
		return "ShootF" if direction.y < 0 else "ShootB"
	return "ShootLR"

func _update_shoot_head(direction: Vector2) -> void:
	var target_anim = _get_shoot_anim(direction)
	# only change animation if direction changed mid-shoot
	if head.animation != target_anim:
		# preserve current frame when switching animations mid-shoot
		var current_frame = head.frame
		head.sprite_frames.set_animation_loop(target_anim, false)
		head.play(target_anim, BobStats.shoot_speed)
		head.frame = current_frame
	# flip sprite horizontally for left/right
	if target_anim == "ShootLR":
		head.scale.x = -1 if direction.x < 0 else 1

func _update_idle_head(direction: Vector2) -> void:
	# default to forward idle if not moving
	if direction == Vector2.ZERO:
		head.play("IdleF")
		return
	
	# vertical movement takes priority over horizontal
	if abs(direction.y) > abs(direction.x):
		# negative y is up in godot's coordinate system
		head.play("IdleB" if direction.y < 0 else "IdleF")
	else:
		head.play("IdleLR")
		# flip sprite horizontally for left/right
		head.scale.x = -1 if direction.x < 0 else 1

func _update_body_animation(direction: Vector2, is_moving: bool) -> void:
	if is_dead:
		return
	
	# handle idle state
	if !is_moving:
		Body.play("IdleF")
		Body.scale.x = 1
		if walk_particles:
			walk_particles.emitting = false
		if SFX2.playing:
			SFX2.stop()
		return

	# handle walking animations
	# vertical movement takes priority over horizontal
	if abs(direction.y) > abs(direction.x):
		# negative y is up in godot's coordinate system
		Body.play("WalkB" if direction.y < 0 else "WalkF")
		Body.scale.x = -1 if direction.y < 0 else 1
	else:
		Body.play("WalkLR")
		# flip sprite horizontally for left/right
		Body.scale.x = -1 if direction.x < 0 else 1

	# enable walk effects
	if walk_particles:
		walk_particles.emitting = true
	if !SFX2.playing:
		SFX2.play()
