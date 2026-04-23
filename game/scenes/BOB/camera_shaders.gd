extends Camera2D

func _ready():
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	add_child(canvas_layer)

	# --- CRT SHADER ---
	var crt_rect = ColorRect.new()
	crt_rect.anchor_right = 1.0
	crt_rect.anchor_bottom = 1.0
	crt_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var crt_material = ShaderMaterial.new()
	crt_material.shader = preload("res://scenes/rooms/crt.gdshader")
	crt_rect.material = crt_material

	canvas_layer.add_child(crt_rect)

	# --- vingette shader ---
	var overlay_rect = ColorRect.new()
	overlay_rect.anchor_right = 1.0
	overlay_rect.anchor_bottom = 1.0
	overlay_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var overlay_material = ShaderMaterial.new()
	overlay_material.shader = preload("res://scenes/rooms/Vignette.gdshader")
	overlay_rect.material = overlay_material

	canvas_layer.add_child(overlay_rect)
