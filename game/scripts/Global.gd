extends Node

var next_spawn = "":
	set(value):
		print("🔵 Global.next_spawn SET to: '", value, "'")
		next_spawn = value
	get:
		print("🟢 Global.next_spawn GET: '", next_spawn, "'")
		return next_spawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("✅ Global.gd initialized")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
