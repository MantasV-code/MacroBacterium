extends Node2D

@export var enemy_scenes: Array[PackedScene]
@export var item_scenes: Array[PackedScene]

@onready var enemy_spawn_points = get_node_or_null("EnemySpawnPoints")
@onready var fixed_enemy_spawn_points = get_node_or_null("FixedEnemySpawnPoints")
@onready var item_spawn_points = get_node_or_null("ItemSpawnPoints")

# pervent enemies and items from spawning more than once
var enemies_spawned := false
var items_spawned := false

# Spawn eneimes from all spawn points in the room
func spawn_enemies() -> void:
	if enemies_spawned:
		return
	
	enemies_spawned = true
	
	spawn_random_enemies()
	spawn_fixed_enemies()


func spawn_random_enemies() -> void:	
	if enemy_spawn_points == null:
		print("No enemy spawn points in this room")
		return
	
	if enemy_scenes.is_empty():
		print("Enemy array list empty")

		return
	
	# Loop each spawn points in Enemy_Spawn_Points and spawn enemy on each
	for point in enemy_spawn_points.get_children():
		if point is Marker2D:
			var enemy_scene = enemy_scenes.pick_random() # Select random enemy from array
			spawn_enemy(enemy_scene, point)
			
	print("Random enemies spawned")

func spawn_fixed_enemies() -> void:
	if fixed_enemy_spawn_points == null:
		print("No fixed spawn points in this room")
		return
	
	for point in fixed_enemy_spawn_points.get_children():
		if point is Marker2D:
			var enemy_scene = get_enemy_from_marker(point)
			
			# skip if enemy not found
			if enemy_scene == null:
				print(point.name, "enemy doesnt exist")
				continue
			
			spawn_enemy(enemy_scene, point)
			
	print("Fixed enemies spawned")

func spawn_enemy(enemy_scene: PackedScene, point: Marker2D) -> void:
	var enemy = enemy_scene.instantiate() # create new instance of the slected enemy scene
	enemy.position = point.position # set enemy's position
	add_child(enemy) # spawn the enemy

# Spawn items from spawn points in the room
func spawn_items() -> void:
	if items_spawned:
		return

	if item_spawn_points == null:
		print("No item spawn points in this room")
		return
	
	if item_scenes.is_empty():
		print("Item array list empty")
		return
	
	items_spawned = true
	
	for point in item_spawn_points.get_children():
		if point is Marker2D:
			var item_scene = item_scenes.pick_random()
			var item = item_scene.instantiate()
			
			item.position = point.position
			add_child(item)
	print("Items spawned")

# Load enemy scene from based on marker name 
func get_enemy_from_marker(point: Marker2D) -> PackedScene:
	# Split marker name to get base name
	var base_name = point.name.split("_")[0]
	
	var path = "res://scenes/Enemies/%s.tscn" % base_name # Build scene path from marker name
	
	# Check if the scene file exists then load it 
	if ResourceLoader.exists(path):
		return load(path)
	
	return null # return null if base name doens't match any files
