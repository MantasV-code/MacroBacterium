extends GutTest

func get_player_and_health():
	var scene = load("res://scenes/BOB/Bob.tscn")
	var bob_root = scene.instantiate() # creat an instance of the player scene
	add_child(bob_root) # add the player scene into the test scene tree
	
	var player = bob_root.get_node("BOB") # get the main player node
	player.add_to_group("player") # add the player to player group 
	
	var health = player.get_node("Health") # get the health node storing the current and max health values
	
	return [player, health]

# test the players health decreasing by the enemies damage zone
func test_damagezone_decreases_player_health():
	var data = get_player_and_health()
	var player = data[0]
	var health = data[1]
	
	health.current_health = 3 

	# simulate damage zone logic
	if player.has_method("decrease_health"):
		player.decrease_health(1)

	assert_eq(health.current_health, 2) # checks that the health is now 2

# test the players health decreasing by enemy bullets
func test_bullet_decreases_player_health():
	var data = get_player_and_health()
	var player = data[0]
	var health = data[1]

	health.current_health = 3

	var bullet_scene = load("res://scenes/BOB/Bullet.tscn") # load the bullet scene
	var bullet = bullet_scene.instantiate()
	add_child(bullet)

	bullet.set_meta("from_enemy", true) # set metadata to simulate an enemy bullet
	bullet.set_meta("damage", 1)

	bullet._on_body_entered(player) # simulate the bullet hitting the player

	assert_eq(health.current_health, 2)


# test the players health increase and not execding the max health
func test_player_increases_health():
	var data = get_player_and_health()
	var player = data[0]
	var health = data[1]

	health.current_health = 2
	health.max_health = 3

	player.increase_health(1)
	assert_eq(health.current_health, 3)

	player.increase_health(1)
	assert_eq(health.current_health, 3)

# test the players max health increasing
func test_player_increase_max_health():
	var data = get_player_and_health()
	var player = data[0]
	var health = data[1]
	
	health.current_health = 3
	health.max_health = 3
	
	player.increase_max_health(1)
	
	assert_eq(health.max_health, 4)
