class_name MovementController 
extends Node

func move_element(
	element			: Node2D, 
	target_position	: Vector2, 
	duration		: float, 
	ease_out		: bool 		= true, 
	ease_in			: bool 		= false
) -> void: 
	var tween = create_tween()
	if ease_out and not ease_in : tween.set_ease(Tween.EASE_OUT)
	if ease_in  and not ease_out: tween.set_ease(Tween.EASE_IN)
	if ease_out and 	ease_in	: tween.set_ease(Tween.EASE_IN_OUT)
	if ease_out or 		ease_in : tween.set_trans(Tween.TRANS_SINE)
	
	target_position = _camera_to_parent(element, target_position)
	target_position = _get_valid_target(element, target_position)
	
	tween.tween_property(element, "position", target_position, duration)
	
func fade_element(
	element 		: Node2D,
	target_position : Vector2,
	duration		: float,
	scale			: Vector2   = Vector2(0,0)
) -> void:
	var tween = create_tween()
	
	target_position = _camera_to_parent(element, target_position)
	
	tween.tween_property(element, "position", target_position, duration)
	tween.parallel().tween_property(element, "scale", scale, duration)
	
func rotate_element(
	element			: Node2D,
	target_rotation : float,
	duration		: float
) -> void:
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	
	tween.tween_property(
		element, 
		"rotation_degrees", 
		element.rotation_degrees + target_rotation,
		duration
	)

func _get_valid_target(element:Node2D, target_position: Vector2) -> Vector2:
	if element is DragableObject:
		return element.get_valid_position(target_position)

	return target_position

func _camera_to_parent(
	element: Node2D,
	target_position: Vector2
) -> Vector2:
	var parent_canvas := element.get_parent() as CanvasItem
	if not parent_canvas == null:
		return parent_canvas.make_canvas_position_local(target_position)
	else:
		return target_position
