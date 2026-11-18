class_name Herb
extends DragableObject

var lifes: int = 2
var overlay_sprite: Sprite2D = null

@export var visual: Sprite2D

func get_damage(hits:int=1):
	lifes -= hits
	check_modulation()
	if lifes == 0: handle_death()

func check_modulation():
	if lifes < 2:
		apply_overlay("#1F4D2E", 0.5)

func apply_overlay(hex_color: String, alpha: float) -> void:
	if visual == null:
		return

	if overlay_sprite == null:
		overlay_sprite = Sprite2D.new()
		add_child(overlay_sprite)

	var color := Color.html(hex_color)
	color.a = alpha

	overlay_sprite.texture 	= visual.texture
	overlay_sprite.position = visual.position
	overlay_sprite.scale 	= visual.scale
	overlay_sprite.rotation = visual.rotation
	overlay_sprite.centered = visual.centered
	overlay_sprite.flip_h 	= visual.flip_h
	overlay_sprite.flip_v 	= visual.flip_v
	overlay_sprite.z_index 	= visual.z_index
	overlay_sprite.modulate	= color


func remove_overlay():
	if overlay_sprite != null:
		overlay_sprite.queue_free()
		overlay_sprite = null


func handle_death():
	pass
