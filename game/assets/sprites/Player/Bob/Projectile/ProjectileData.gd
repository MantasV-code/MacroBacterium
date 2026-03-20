extends Resource
class_name ProjectileData

@export var speed: float = 500
@export var damage: int = 10
@export var piercing: bool = false
@export var count: int = 1          # how many bullets to fire
@export var spread: float = 0.0     # spread angle in degrees between bullets
@export var color: Color = Color.WHITE
@export var scale_multiplier: float = 3.0
@export var lifetime: float = 200000.0
