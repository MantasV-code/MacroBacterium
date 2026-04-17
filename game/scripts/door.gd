extends Node2D

@export var spawn_target: String
@export var direction := "forward" # "forward" or "back"

var is_triggered = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body is CharacterBody2D and not is_triggered:
		print("Entered: ", body.name)
		is_triggered = true
		call_deferred("change_room_deferred")

func change_room_deferred():
	print("next room...")
	print("spawn_target set to:", spawn_target)
	print("Door:", name)
	print("Direction:", direction)
	print("Spawn target:", spawn_target)

	Global.next_spawn = spawn_target

	var manager = get_tree().get_first_node_in_group("room_manager")
	if manager == null:
		print("❌ Room Manager not found")
		return

	if direction == "forward":
		manager.load_next_room()
	elif direction == "back":
		manager.load_prev_room()

func _ready() -> void:
	is_triggered = false
