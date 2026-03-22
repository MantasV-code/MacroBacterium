extends CharacterBody2D
const SPEED = 150.0
const ACCELERATION = 2000.0
const FRICTION = 2800.0
@onready var head = %head
@onready var Body = %Body
@onready var SFX1 = %Shoot

@export var max_health: int = 3
var current_health: int

var is_shooting = false

func _ready() -> void:
	current_health = max_health
	head.sprite_frames.set_animation_loop("ShootF", false)
	head.sprite_frames.set_animation_loop("ShootB", false)
	head.sprite_frames.set_animation_loop("ShootLR", false)
	
#decrease bobs health	
func decrease_health(amount: int) -> void:
	current_health -= amount
	print("Bob's Health: ", current_health)
	
	if current_health <= 0:
		die()
		
# increase bobs health 
func increase_health(amount: int) -> void:
	if current_health < 3:
		current_health += amount
		print("Bob's Health: ", current_health )
	else:
		print("Bob has full health")
	
# remove bob from the game
func die() -> void:
	print("Player died")
	queue_free()
	
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
