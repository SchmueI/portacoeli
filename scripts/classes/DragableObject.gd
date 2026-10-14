class_name DragableObject
extends ClickableObject

enum BoundaryMode {
	NONE,
	KEEP_INSIDE,
	COVER_VIEWPORT
}

@export var intScale: float = 0.13
@export var dragScale: float = 0.2
@export var boundary_mode: BoundaryMode = BoundaryMode.NONE

signal moved

var drag_offset: Vector2 = Vector2.ZERO


func _on_drag_started(event: InputEventScreenDrag) -> void:
	var touch_position := get_touch_position_in_parent(event.position)

	drag_offset = position - touch_position

	if intScale != dragScale:
		scale = Vector2(dragScale, dragScale)

	position = get_valid_position(position)


func _on_drag(event: InputEventScreenDrag) -> void:
	var touch_position := get_touch_position_in_parent(event.position)

	var target_position := touch_position + drag_offset

	position = get_valid_position(target_position)


func _on_drag_finished(_event: InputEventScreenTouch) -> void:
	if intScale != dragScale:
		scale = Vector2(intScale, intScale)

	position = get_valid_position(position)

	moved.emit()


func get_touch_position_in_parent(viewport_position: Vector2) -> Vector2:
	return parent_canvas.make_canvas_position_local(viewport_position)


func get_valid_position(target_position: Vector2) -> Vector2:
	if boundary_mode == BoundaryMode.NONE:
		return target_position

	var original_position := position

	position = target_position

	var object_rect := _get_touch_area_viewport_rect()
	var viewport_rect := get_viewport().get_visible_rect()

	position = original_position

	if object_rect.size == Vector2.ZERO:
		return target_position

	var correction := Vector2.ZERO

	match boundary_mode:
		BoundaryMode.KEEP_INSIDE:
			correction = _keep_inside(object_rect, viewport_rect)

		BoundaryMode.COVER_VIEWPORT:
			correction = _cover_viewport(object_rect, viewport_rect)

	return target_position + _viewport_delta_to_parent(correction)


func _keep_inside(
	object_rect: Rect2,
	viewport_rect: Rect2
) -> Vector2:

	var correction := Vector2.ZERO

	if object_rect.size.x <= viewport_rect.size.x:
		if object_rect.position.x < viewport_rect.position.x:
			correction.x = viewport_rect.position.x - object_rect.position.x
		elif object_rect.end.x > viewport_rect.end.x:
			correction.x = viewport_rect.end.x - object_rect.end.x
	else:
		correction.x = viewport_rect.get_center().x - object_rect.get_center().x


	if object_rect.size.y <= viewport_rect.size.y:
		if object_rect.position.y < viewport_rect.position.y:
			correction.y = viewport_rect.position.y - object_rect.position.y
		elif object_rect.end.y > viewport_rect.end.y:
			correction.y = viewport_rect.end.y - object_rect.end.y
	else:
		correction.y = viewport_rect.get_center().y - object_rect.get_center().y


	return correction


func _cover_viewport(
	object_rect: Rect2,
	viewport_rect: Rect2
) -> Vector2:

	var correction := Vector2.ZERO

	if object_rect.size.x >= viewport_rect.size.x:
		if object_rect.position.x > viewport_rect.position.x:
			correction.x = viewport_rect.position.x - object_rect.position.x
		elif object_rect.end.x < viewport_rect.end.x:
			correction.x = viewport_rect.end.x - object_rect.end.x
	else:
		correction.x = viewport_rect.get_center().x - object_rect.get_center().x


	if object_rect.size.y >= viewport_rect.size.y:
		if object_rect.position.y > viewport_rect.position.y:
			correction.y = viewport_rect.position.y - object_rect.position.y
		elif object_rect.end.y < viewport_rect.end.y:
			correction.y = viewport_rect.end.y - object_rect.end.y
	else:
		correction.y = viewport_rect.get_center().y - object_rect.get_center().y


	return correction


func _viewport_delta_to_parent(delta: Vector2) -> Vector2:
	var origin := get_touch_position_in_parent(Vector2.ZERO)
	var target := get_touch_position_in_parent(delta)

	return target - origin


func _get_touch_area_viewport_rect() -> Rect2:
	var points: Array[Vector2] = []

	for child in touch_area.get_children():

		if child is CollisionShape2D:
			var collision := child as CollisionShape2D

			if collision.shape == null:
				continue

			var rect := collision.shape.get_rect()

			var corners: Array[Vector2] = [
				rect.position,
				Vector2(rect.end.x, rect.position.y),
				rect.end,
				Vector2(rect.position.x, rect.end.y)
			]

			for corner in corners:
				points.append(
					collision.get_global_transform_with_canvas() * corner
				)


		elif child is CollisionPolygon2D:
			var polygon := child as CollisionPolygon2D

			for point in polygon.polygon:
				points.append(
					polygon.get_global_transform_with_canvas() * point
				)


	if points.is_empty():
		return Rect2()


	var minimum := points[0]
	var maximum := points[0]

	for point in points:
		minimum.x = min(minimum.x, point.x)
		minimum.y = min(minimum.y, point.y)

		maximum.x = max(maximum.x, point.x)
		maximum.y = max(maximum.y, point.y)


	return Rect2(
		minimum,
		maximum - minimum
	)
