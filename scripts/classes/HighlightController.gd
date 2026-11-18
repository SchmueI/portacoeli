class_name HighlightController
extends MovementController

func highlight_element(element:Node2D, index:int=100):
	element.z_index = index

func scale_element(element:Node2D, scale:float):
	var tween = create_tween()
	tween.tween_property(element, "scale", Vector2(scale,scale), 0.3)

func scale_element_immediately(element:Node2D, scale:float):
	var tween = create_tween()
	tween.tween_property(element, "scale", Vector2(scale,scale), 0)

func celebrate_element(
	element: Node2D,
	target_position: Vector2,
	duration: float,
	final_scale: Vector2
) -> void:
	var tween = create_tween()

	var center := get_viewport().get_visible_rect().size / 2
	center = _camera_to_parent(element, center)

	var target := _camera_to_parent(element, target_position)

	var big_scale := final_scale * 3

	# 1. Zur Mitte und größer
	tween.tween_property(element, "position", center, duration * 0.6)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(
		element,
		"scale",
		big_scale,
		duration * 0.4
	)

	# 2. Zurück zur Zielposition und kleiner
	tween.tween_property(element, "position", target, duration * 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)

	tween.parallel().tween_property(
		element,
		"scale",
		final_scale,
		duration * 0.6
	)
