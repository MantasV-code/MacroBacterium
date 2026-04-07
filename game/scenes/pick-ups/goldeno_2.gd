extends Area2D

@export_group("Settings")
@export var upgrade_name: String = "HealthUp"
@export var display_name: String = "Max health up!!"
@export var item_color: Color = Color.GOLD
@onready var ItemSprite = %ItemSprite

@onready var sprite = $AnimatedSprite2D
@onready var label = $Label 


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	label.hide()
	label.text = display_name
	label.modulate = item_color
	ItemSprite.play("default")
	
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Bob" or body.is_in_group("player"):
		BobStats.apply_upgrade("health_up")
		_collect_effect()
		
func _collect_effect() -> void:
	monitoring = false
	if has_node("AnimationPlayer"):
		$AnimationPlayer.stop()
		
	var tween = create_tween().set_parallel(true)
	label.show()

	tween.tween_property(label, "position:y", label.position.y - 60, 1.5)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
		
	tween.chain().tween_property(label, "modulate:a", 0.0, 0.8)

	# --- ITEM VISUALS ---
	tween.tween_property(ItemSprite, "modulate:a", 0.0, 0.3)
	tween.tween_property(ItemSprite, "scale", Vector2(1.5, 1.5), 0.3)
	
	tween.chain().tween_callback(queue_free)
