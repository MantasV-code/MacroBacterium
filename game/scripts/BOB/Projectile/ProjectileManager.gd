extends Node

var data := ProjectileData.new()

func apply_upgrade(upgrade: String) -> void:
	match upgrade:
		"double_shot":
			data.count = 2
			data.spread = 15.0
		"triple_shot":
			data.count = 3
			data.spread = 20.0
		"piercing":
			data.piercing = true
		"red":
			data.color = Color.RED
			data.damage = 20
		"fast":
			data.speed = 1400.0
		"big":
			data.scale_multiplier = 2.0
