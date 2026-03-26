extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$fly.play("fly")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_fly_animation_finished(anim_name: StringName) -> void:
	fade_out()
	
	
func fade_out():
	var tween = create_tween()
	tween.tween_property($Fade, "modulate:a", 1.0, 0.4)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/intro/ship_crash.tscn")
	
