extends Area2D

var direction := Vector2.ZERO
var data: ProjectileData
var hit := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	print("bullet ready, monitoring: ", monitoring)

func setup(dir: Vector2, projectile_data: ProjectileData) -> void:
	direction = dir
	data = projectile_data
	
	var sprite = $AnimatedSprite2D
	sprite.play("Shoot")
	rotation = direction.angle()
	
	var mat = ShaderMaterial.new()
	mat.shader = preload("res://Bob/Projectile/Bullet.gdshader")
	sprite.material = mat
	
	scale = Vector2.ONE * data.scale_multiplier
	
	var timer = get_tree().create_timer(data.lifetime)
	timer.timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	if !hit:
		position += direction * data.speed * delta

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
