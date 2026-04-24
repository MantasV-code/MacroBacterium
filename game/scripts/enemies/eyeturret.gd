extends CharacterBody2D
@onready var deathsound = %Death
@onready var Turnsound = %Turn
@onready var hurtbox = %Hurtbox
@onready var hurtbox2 = %Hurtbox2
var player: Node2D
var bullet_scene = preload("res://scenes/BOB/Bullet.tscn")
@onready var shoot_timer = %ShootTimer
@onready var sprite = $AnimatedSprite2D
var is_dead = false
var current_direction = ""  # Track current animation

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func decrease_health(amount: int) -> void:
	$Health.decrease_health(amount)

func on_death() -> void:
	is_dead = true
	shoot_timer.stop()
	sprite.play("Spin")
	await sprite.animation_finished
	sprite.play("Death")
	await sprite.animation_finished
	queue_free()

func _process(delta: float) -> void:
	if player and not is_dead:
		update_sprite_direction()

func update_sprite_direction() -> void:
	var direction = (player.global_position - global_position).normalized()
	var angle = direction.angle()
	
	# Convert angle to 0-360 degrees
	var degrees = rad_to_deg(angle)
	if degrees < 0:
		degrees += 360
	
	var new_direction = ""
	
	# Determine which of 8 directions based on angle
	if degrees >= 337.5 or degrees < 22.5:
		new_direction = "LookR"
	elif degrees >= 22.5 and degrees < 67.5:
		new_direction = "LookFR"
	elif degrees >= 67.5 and degrees < 112.5:
		new_direction = "LookF"
	elif degrees >= 112.5 and degrees < 157.5:
		new_direction = "LookFL"
	elif degrees >= 157.5 and degrees < 202.5:
		new_direction = "LookL"
	elif degrees >= 202.5 and degrees < 247.5:
		new_direction = "LookBL"
	elif degrees >= 247.5 and degrees < 292.5:
		new_direction = "LookB"
	elif degrees >= 292.5 and degrees < 337.5:
		new_direction = "LookBR"
	
	# Only play sound and change sprite if direction actually changed
	if new_direction != current_direction:
		current_direction = new_direction
		sprite.play(new_direction)
		Turnsound.play()

func _on_shoot_timer_timeout() -> void:
	if player and not is_dead:
		fire_at_player()

func fire_at_player() -> void:
	var direction = (player.global_position - global_position).normalized()
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = global_position
	bullet.setup(direction, TurretStats, Vector2.ZERO, true)
