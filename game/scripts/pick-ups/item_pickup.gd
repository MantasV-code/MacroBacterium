extends Area2D

@export_group("Settings")
@export var item_type: String = "" # health or power_up
@export var item_effect: String = ""
@export var display_name: String = ""
@export var value: int = 0
@export var item_color: Color = Color.WHITE
@onready var ItemSprite = %ItemSprite
@onready var label = $Label 


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	label.hide()
	label.text = display_name
	label.modulate = item_color

	
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Bob" or body.is_in_group("player"):
		
		if item_type == "power_up":
			BobStats.apply_effect(item_effect)
		if item_type == "health":
			BobStats.modify_health(item_effect, value)
		_collect_effect()
		
func _collect_effect() -> void:
	set_deferred("monitoring", false) # stop detecting player so item can't be picked up again
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
