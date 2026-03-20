extends CharacterBody2D
@onready var _animated_sprite = $AnimatedSprite2D
const SPEED = 300.0
var is_shooting = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and !is_shooting:
		shoot()

	var direction := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()

	if direction != Vector2.ZERO:
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)

	# Flip sprite based on horizontal direction
	if direction.x < 0:
		_animated_sprite.flip_h = true
	elif direction.x > 0:
		_animated_sprite.flip_h = false

	if !is_shooting:
		if direction != Vector2.ZERO:
			_animated_sprite.play("Walk")
		else:
			_animated_sprite.play("Idle")

	move_and_slide()

func shoot():
	is_shooting = true
	_animated_sprite.sprite_frames.set_animation_loop("Shoot", false)
	_animated_sprite.sprite_frames.set_animation_speed("Shoot", 30)
	_animated_sprite.play("Shoot")
	print("shoot")
	await _animated_sprite.animation_finished
	is_shooting = false
