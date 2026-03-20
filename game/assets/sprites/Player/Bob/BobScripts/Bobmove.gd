extends CharacterBody2D
const SPEED = 600.0
const ACCELERATION = 2000.0
const FRICTION = 2800.0
@onready var head = %head
@onready var Body = %Body
@onready var SFX1 = %Shoot
@onready var FaceHole = %FaceHole
var bullet_scene = preload("res://Bullet.tscn")

var is_shooting = false

func _ready() -> void:
	scale = Vector2(0.5, 0.5)
	head.sprite_frames.set_animation_loop("ShootF", false)
	head.sprite_frames.set_animation_loop("ShootB", false)
	head.sprite_frames.set_animation_loop("ShootLR", false)
	
func _physics_process(delta: float) -> void:
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
		velocity = velocity.move_toward(move_direction * SPEED, ACCELERATION * delta)
		_update_body(move_direction, true)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		_update_body(Vector2.ZERO, false)

	if is_shooting and aim_direction != Vector2.ZERO:
		_update_shoot_head(aim_direction)
	elif !is_shooting:
		_update_idle_head(move_direction)

	move_and_slide()

func _get_shoot_anim(direction: Vector2) -> String:
	if abs(direction.y) > abs(direction.x):
		return "ShootF" if direction.y < 0 else "ShootB"
	else:
		return "ShootLR"

func _update_shoot_head(direction: Vector2) -> void:
	var target_anim = _get_shoot_anim(direction)
	if head.animation != target_anim:
		var current_frame = head.frame
		head.sprite_frames.set_animation_loop(target_anim, false) 
		head.play(target_anim)
		head.frame = current_frame
	if target_anim == "ShootLR":
		head.scale.x = -1 if direction.x < 0 else 1

func _update_idle_head(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		head.play("IdleF")
		return
	if abs(direction.y) > abs(direction.x):
		head.play("IdleB" if direction.y < 0 else "IdleF")
	else:
		head.play("IdleLR")
		head.scale.x = -1 if direction.x < 0 else 1

func shoot(direction: Vector2) -> void:
	is_shooting = true
	SFX1.play()
	var anim = _get_shoot_anim(direction)
	head.sprite_frames.set_animation_loop(anim, false)
	head.play(anim)

	_spawn_bullets(direction)

	await head.animation_finished
	is_shooting = false

func _update_body(direction: Vector2, is_moving: bool) -> void:
	if !is_moving:
		Body.play("IdleF")
		Body.scale.x = 1
		return
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

func _spawn_bullets(direction: Vector2) -> void:
	var data = ProjectileManager.data
	var count = data.count
	var spread = deg_to_rad(data.spread)
	
	for i in count:
		var angle_offset = 0.0
		if count > 1:
			angle_offset = lerp(-spread / 2.0, spread / 2.0, float(i) / float(count - 1))
		
		var bullet_dir = direction.rotated(angle_offset)
		var bullet = bullet_scene.instantiate()
		get_parent().add_child(bullet)
		bullet.global_position = FaceHole.global_position
		bullet.setup(bullet_dir, data)
		print("bullet position: ", bullet.global_position)
