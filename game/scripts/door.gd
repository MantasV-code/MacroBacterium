extends Node2D

@export var next_scene: String #set this in the inspector
@export var spawn_target: String #where player appears when transition into next room

var is_triggered = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Entered: ", body.name)
	
	if body.is_in_group("player") and not is_triggered:
		is_triggered = true
		change_room()

		
func change_room():
	print("changing to scene: ", next_scene)
	Global.next_spawn = spawn_target
	call_deferred("_go_to_scene")

func _go_to_scene():
	get_tree().change_scene_to_file(next_scene)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
