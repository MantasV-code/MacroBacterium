extends Node2D




# Called when the node enters the scene tree for the first time.
func _ready():
	print("Looking for:", Global.next_spawn)
	print("Children:", get_children())
	
	if Global.next_spawn != "":
		if has_node(Global.next_spawn):
			print("FOUND SPAWN")
			var spawn = get_node(Global.next_spawn)
			$Bob.global_position = spawn.global_position
		else:
			print("Spawn NOT found")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
