extends Area2D

var velocity_vec := Vector2.ZERO
var hit := false
var is_piercing := false # Local copy of piercing status

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func setup(dir: Vector2, stats: Node, player_velocity: Vector2 = Vector2.ZERO) -> void:
	# 1. Calculate Velocity
	var speed_val = stats.speed + max(player_velocity.dot(dir), 0.0)
	velocity_vec = dir * speed_val
	
	# 2. Store Piercing
	is_piercing = stats.piercing
	
	# 3. Visuals
	rotation = dir.angle()
	scale = Vector2.ONE * stats.scale_multiplier
	
	var sprite = $AnimatedSprite2D
	sprite.play("Shoot")
	
	# Apply Tint
	var mat = ShaderMaterial.new()
	mat.shader = preload("res://scripts/BOB/Projectile/Bullet.gdshader")
	mat.set_shader_parameter("tint", stats.color)
	sprite.material = mat
	
	set_meta("damage", stats.damage) 

	get_tree().create_timer(stats.lifetime).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	if !hit:
		position += velocity_vec * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("decrease_health"):
		body.decrease_health(get_meta("damage"))
	
	if not is_piercing:
		_on_hit()

func _on_area_entered(area: Node2D) -> void:
	if area.is_in_group("enemy_hitbox"):
		area.get_parent().take_damage(get_meta("damage"))
		if not is_piercing:
			_on_hit()

func _on_hit() -> void:
	if hit: return
	hit = true
	velocity_vec = Vector2.ZERO
	var sprite = $AnimatedSprite2D
	sprite.play("Hit")
	sprite.animation_finished.connect(queue_free)
