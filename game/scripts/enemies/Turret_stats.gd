extends Node

# --- Turret Projectile Stats ---
@export_group("Projectiles")
@export var speed: float = 100.0
@export var damage: int = 1
@export var piercing: bool = false
@export var count: int = 1         
@export var spread: float = 0.0    
@export var color: Color = Color.RED
@export var scale_multiplier: float = 1
@export var lifetime: float = 2.0
@export var shoot_speed: float = 1
