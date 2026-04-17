extends Node2D

@export var cockpit_scene: PackedScene
@export var room_arr: Array[PackedScene]
@export var boss_room: PackedScene

@export var rooms_to_pick := 4

var selected_rooms: Array = []
var current_room_idx = 0
var current_room_instance = null
var previous_rooms: Array = []
var room_root = null

@onready var player = $Bob


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("room_manager")
	randomize()
	run_setup()
	load_next_room()
	
#CREATE ORDER OF RUN
func run_setup():
	selected_rooms.clear()
	
	#Starting room
	selected_rooms.append(cockpit_scene)
	
	#Shuffle and pick rooms
	room_arr.shuffle()
	
	for i in range(min(rooms_to_pick, room_arr.size())):
		selected_rooms.append(room_arr[i])
		
	#End with boss room
	selected_rooms.append(boss_room)
	
#LOAD NEXT ROOM
func load_next_room():
	
	# Remove old room
	if current_room_instance:
		current_room_instance.queue_free()
		await get_tree().process_frame
	
	# Check end
	if current_room_idx >= selected_rooms.size():
		print("🎉 Game Complete!")
		return
	
	# Load new room
	current_room_instance = selected_rooms[current_room_idx].instantiate()
	add_child(current_room_instance)
	
	# Get OriginRoom or fallback
	room_root = current_room_instance.get_node_or_null("OriginRoom")
	if room_root == null:
		room_root = current_room_instance
	
	# 🔥 RESET POSITION (VERY IMPORTANT)
	room_root.position = Vector2.ZERO
	
	current_room_idx += 1
	
	# Spawn player
	await get_tree().process_frame
	spawn_player()

#BACKTRACK
func load_prev_room():
	if current_room_idx <= 1:
		return
		
	current_room_idx -= 2
	load_next_room()
	
#STARTING POINT 

#SPAWN PLAYER
func spawn_player():
	print("\n=== SPAWNING PLAYER ===")
	print("ROOM:", current_room_instance.name)
	print("Global.next_spawn:", Global.next_spawn)

	var spawn = null

	# First room only
	if Global.next_spawn == "":
		var start_spawn = current_room_instance.find_child("Start_Spawn", true, false)

		if start_spawn != null:
			player.global_position = start_spawn.global_position
			print("Spawned at Start_Spawn:", player.global_position)
		else:
			print("Start_Spawn not found")

		Global.next_spawn = ""
		return

	# Normal room transition
	print("Trying to find:", Global.next_spawn)
	spawn = room_root.find_child(Global.next_spawn, true, false)

	if spawn == null:
		print("Exact spawn not found, trying fallback order...")
		spawn = current_room_instance.find_child("Spawn_Down", true, false)
	if spawn == null:
		spawn = current_room_instance.find_child("Spawn_Up", true, false)
	if spawn == null:
		spawn = current_room_instance.find_child("Spawn_Left", true, false)
	if spawn == null:
		spawn = current_room_instance.find_child("Spawn_Right", true, false)

	if spawn != null:
		print("Spawn FOUND IN ROOM:", current_room_instance.name, "->", spawn.name)
		print("Spawn LOCAL:", spawn.position)
		print("Spawn GLOBAL:", spawn.global_position)

		# MOVE BOB TO THE FOUND SPAWN
		#player.global_position = spawn.global_position
		player.global_position = spawn.global_position 

		print("Player placed at:", player.global_position)
	else:
		print("No spawn found at all", Global.next_spawn)
		print("Problem Room", current_room_instance.name)

	Global.next_spawn = ""
	
func _input(event):
	if event.is_action_pressed("ui_accept"):  # Space bar or Enter
		if current_room_instance:
			print("\n=== DEBUG INFO ===")
			print("Room: ", current_room_instance.name)
			print("Room position: ", current_room_instance.position)
			print("Player position: ", player.global_position)
			print("Player is child of: ", player.get_parent().name)
			
			# Check if player is inside room bounds
			var room_rect = Rect2(current_room_instance.global_position, Vector2(1000, 800))
			print("Is player in room? ", room_rect.has_point(player.global_position))

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
# In Map1.gd - add this debug function
func _process(delta):
	if Input.is_action_just_pressed("ui_home"):  # Press Home key
		if current_room_instance:
			print("\n=== MANUAL DEBUG ===")
			print("Room: ", current_room_instance.name)
			print("Room position: ", current_room_instance.position)
			print("Room global: ", current_room_instance.global_position)
			print("Player position: ", player.global_position)
			print("Player local: ", player.position)
			
			# Find all spawn points
			for child in current_room_instance.get_children():
				if "Spawn" in child.name:
					print("Spawn ", child.name, " pos: ", child.global_position)
