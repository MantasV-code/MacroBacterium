extends Area2D

var direction := Vector2.ZERO
var data: ProjectileData
var hit := false

@export var damage: int = 1

func _ready() -> void:
	# Connect collision signals
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

# Called after adding to scene, sets up bullet properties
func setup(dir: Vector2, projectile_data: ProjectileData, inherited_velocity: Vector2 = Vector2.ZERO) -> void:
	direction = dir
	data = projectile_data
	
	# Add forward momentum from player velocity
	var velocity_bonus = inherited_velocity.dot(dir)
	direction = dir * (data.speed + max(velocity_bonus, 0.0))
	
	var sprite = $AnimatedSprite2D
	sprite.play("Shoot")
	
	# Face direction of travel
	rotation = dir.angle()
	
	# Apply tint shader
	var mat = ShaderMaterial.new()
	mat.shader = preload("res://scripts/BOB/Projectile/Bullet.gdshader")
	mat.set_shader_parameter("tint", data.color)
	sprite.material = mat
	
	scale = Vector2.ONE * data.scale_multiplier
	
	# Despawn after lifetime
	var timer = get_tree().create_timer(data.lifetime)
	timer.timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	# Move in direction until hit
	if !hit:
		position += direction * delta

# Hit a wall or physics body
func _on_body_entered(body: Node2D) -> void:
	_on_hit()
	
	# check if object can decrease health
	if body.has_method("decrease_health"):
		body.decrease_health(damage) # decrease health

# Hit an Area2D, deal damage if enemy
func _on_area_entered(area: Node2D) -> void:
	if area.is_in_group("enemy_hitbox"):
		area.get_parent().take_damage(data.damage)
	_on_hit()

# Stop moving, play hit animation then despawn
func _on_hit() -> void:
	if hit:
		return
	hit = true
	var sprite = $AnimatedSprite2D
	sprite.sprite_frames.set_animation_speed("Hit", 30)
	sprite.play("Hit")
	sprite.animation_finished.connect(queue_free)
