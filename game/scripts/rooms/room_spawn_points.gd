extends Node2D

#var enemy_scene = preload("res://scenes/Enemies/FlyingBac.tscn")
@export var enemy_scenes: Array[PackedScene]
@onready var enemy_spawn_point = $EnemySpawnPoints.get_children()

#func _ready() -> void:
	#spawn_enemies()

# pervent enemies from spawning more than once
var enemies_spawned := false

func spawn_enemies() -> void:
	if enemies_spawned:
		return
	
	enemies_spawned = true
	
	for point in enemy_spawn_point:
		if point is Marker2D:
			var enemy_scene = enemy_scenes.pick_random()
			var enemy = enemy_scene.instantiate()
			
			enemy.position = point.position
			add_child(enemy)
	
	print("Enemies spawned")
	
