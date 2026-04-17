extends Node2D

#references
@onready var tilemap = $TileMap
@onready var player  = $Bob

#map size
const MAP_HEIGHT = 30
const MAP_WIDTH = 30

#tileset - chnage these to match tileset
const SOURCE_ID = 0

const FLOOR_ATLAS = Vector2i(8,2)
const WALL_ATLAS = Vector2i(6,10)

#room settings
#min and max of rooms
const ROOM_SIZE_MIN = 5
const ROOM_SIZE_MAX = 10

#generate 4 rooms (try)
const MAX_ROOMS = 4

#store center position of rooms
var rooms: Array = []
var room_center: Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize() #random the map
	generate_instance()
	
#Main Generation
func generate_instance():
	fill_with_walls() #fill map with walls
	
	#for loop to create rooms
	for i in range(MAX_ROOMS):
		
		#randomize room size
		var width = randi_range(ROOM_SIZE_MIN, ROOM_SIZE_MAX)
		var height = randi_range(ROOM_SIZE_MIN, ROOM_SIZE_MAX)
		
		#randomize the position
		var x = randi_range(1, MAP_WIDTH - width - 1)
		var y = randi_range(1, MAP_HEIGHT - height - 1)
		
		#create recentagle shape room
		var new_room = Rect2i(x, y, width, height)
		
		#if rooms overlapping skip
		if is_overlapping(new_room):
			continue
		
		#create room
		create_room(new_room)
		
		var center = get_center(new_room)
		room_center.append(center)
		
		if room_center.size() > 1:
			connect_rooms(room_center[-2], center)
			
		rooms.append(new_room)
		
	#spawn player after map is built
	spawn_player()

#SPAWN PLAYER
func spawn_player():
	if room_center.size() > 0:
		var spawn_posiiton = room_center[0]
		player.global_position = tilemap.map_to_local(spawn_posiiton)
		

#ROOM CREATION
func create_room(room: Rect2i):
	for x in range(room.position.x, room.position.x + room.size.x):
		for y in range(room.position.y, room.position.y + room.size.y):
			tilemap.set_cell(0, Vector2i(x,y), SOURCE_ID, FLOOR_ATLAS)
			
#CORRIDOR CREATION
func connect_rooms(a: Vector2i, b: Vector2i):
	if randi() % 2 == 0:
		create_horiztional_corridor(a.x, b.x, a.y)
		create_vertical_corridor(a.y, b.y, b.x)
	
	else:
		create_vertical_corridor(a.y, b.y, a.x)
		create_horiztional_corridor(a.x, b.x, b.y)
		
func create_horiztional_corridor(x1: int, x2: int, y:int):
	for x in range(min(x1, x2), max(x1,x2) + 1):
		tilemap.set_cell(0, Vector2i(x,y), SOURCE_ID, FLOOR_ATLAS)
		
func create_vertical_corridor(y1: int, y2: int, x: int):
	for y in range(min(y1, y2), max(y1, y2) + 1):
		tilemap.set_cell(0, Vector2i(x,y), SOURCE_ID, FLOOR_ATLAS)
		
		
#WALL FILL
func fill_with_walls():
	for x in range(MAP_WIDTH):
		for y in range(MAP_HEIGHT):
			tilemap.set_cell(0, Vector2i(x,y), SOURCE_ID, WALL_ATLAS)
			
#OVERLAPPING CHECK
func is_overlapping(new_room: Rect2i) -> bool:
	for room in rooms:
		if new_room.grow(1).intersects(room):
			return true
		
	return false
	
#HELPERS
func get_center(room: Rect2i) -> Vector2i:
	return Vector2i(
		room.position.x + room.size.x / 2,
		room.position.y + room.size.y / 2
	)


	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
	
#NOTES:
#MAP SIZE = MAP_WIDTH / MAP_HEIGHT (BIGGER = larger dungeon)
#ROOM COUNT = MAX_ROOMS
#ROOM SIZE = ROOM_SIZE_MIN / ROOM_SIZE_MAX (bigger rooms)
#VISUALS = FLOOR_ALTAS, WALL_ALTAS
