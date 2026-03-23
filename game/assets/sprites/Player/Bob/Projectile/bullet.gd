extends Area2D

var direction := Vector2.ZERO
var data: ProjectileData
var hit := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	print("bullet ready, monitoring: ", monitoring)

func setup(dir: Vector2, projectile_data: ProjectileData, inherited_velocity: Vector2 = Vector2.ZERO) -> void:
	direction = dir
	data = projectile_data
	var velocity_bonus = inherited_velocity.dot(dir)
	direction = dir * (data.speed + max(velocity_bonus, 0.0))
	
	var sprite = $AnimatedSprite2D
	sprite.play("Shoot")
	rotation = dir.angle()
	
	var mat = ShaderMaterial.new()
	mat.shader = preload("res://assets/sprites/Player/Bob/Projectile/Bullet.gdshader")
	mat.set_shader_parameter("tint", data.color)
	sprite.material = mat
	
	scale = Vector2.ONE * data.scale_multiplier
	
	var timer = get_tree().create_timer(data.lifetime)
	timer.timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	if !hit:
		position += direction * delta 

func _on_body_entered(body: Node2D) -> void:
	print("body hit: ", body.name)
	_on_hit()

func _on_area_entered(area: Node2D) -> void:
	print("area hit: ", area.name)
	if area.is_in_group("enemy_hitbox"):
		area.get_parent().take_damage(data.damage)
	_on_hit()

func _on_hit() -> void:
	if hit:
		return
	hit = true
	var sprite = $AnimatedSprite2D
	sprite.sprite_frames.set_animation_speed("Hit", 30)
	sprite.play("Hit")	
	sprite.animation_finished.connect(queue_free)
