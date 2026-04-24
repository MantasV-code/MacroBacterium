extends Node2D

@export var target_spawn: NodePath
@export var locked := false
@export var target_room: NodePath

var is_triggered := false

func _ready() -> void:
	is_triggered = false
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body is CharacterBody2D and not is_triggered:
		if locked:
			print("Door is locked")
			return
			
		is_triggered = true
		call_deferred("change_room", body)
		
func change_room(body: Node2D) -> void:
	var spawn = get_node_or_null(target_spawn)
	var room = get_node_or_null(target_room)
	
	if spawn == null:
		print("Spawn not found at door:", name)
		is_triggered = false
		return
		
	if room == null:
		print("room not found")
		is_triggered = false
		return
		
	if "velocity" in body:
		body.velocity = Vector2.ZERO
		
	body.global_position = spawn.global_position
	
	get_tree().current_scene.set_camera_limits(room)
	
	await get_tree().physics_frame
	
	if "velocity" in body:
		body.velocity = Vector2.ZERO
		
	is_triggered = false
	
