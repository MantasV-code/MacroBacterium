extends Node2D

@onready var pause_menu = $PauseMenu
var enemy_scene = preload("res://scenes/Enemies/FlyingBac.tscn")
@onready var spawn_point: Marker2D = $EnemySpawn

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Looking for:", Global.next_spawn)
	print("Children:", get_children())
	spawn()
	
	if Global.next_spawn != "":
		if has_node(Global.next_spawn):
			print("FOUND SPAWN")
			var spawn = get_node(Global.next_spawn)
			$Bob.global_position = spawn.global_position
		else:
			print("Spawn NOT found")

func spawn():
	var enemy = enemy_scene.instantiate()
	enemy.position = spawn_point.position
	add_child(enemy)
	print("enemy spawned")


func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause():
	var is_paused = get_tree().paused
	get_tree().paused = !is_paused
	pause_menu.visible = !is_paused
	
	if !is_paused:
		pause_menu.resume_btn.grab_focus()
