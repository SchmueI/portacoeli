class_name ClickableObject
extends Node2D

signal clicked

@export var drag_threshold: float = 10.0

var active_touch: int = -1
var touch_start_position: Vector2 = Vector2.ZERO
var is_dragging: bool = false
var touch_enabled: bool = true

@onready var touch_area: Area2D = $TouchArea
@onready var parent_canvas: CanvasItem = get_parent() as CanvasItem


func _ready() -> void:
	# Bei überlappenden TouchAreas erhält nur das oberste Objekt
	# das Input-Event.
	var viewport := get_viewport()
	viewport.physics_object_picking_sort = true
	viewport.physics_object_picking_first_only = true

	touch_area.input_event.connect(_on_touch_area_input_event)


func _on_touch_area_input_event(
	_viewport: Node,
	event: InputEvent,
	_shape_index: int
) -> void:

	if not touch_enabled:
		return

	if event is InputEventScreenTouch:
		if event.pressed and active_touch == -1:
			active_touch = event.index
			touch_start_position = event.position
			is_dragging = false

			get_viewport().set_input_as_handled()


func _input(event: InputEvent) -> void:
	if active_touch == -1:
		return


	if event is InputEventScreenDrag:
		if event.index != active_touch:
			return

		if not is_dragging:
			var distance : float = event.position.distance_to(
				touch_start_position
			)

			if distance >= drag_threshold:
				is_dragging = true
				_on_drag_started(event)

		if is_dragging:
			_on_drag(event)

		get_viewport().set_input_as_handled()


	elif event is InputEventScreenTouch:
		if event.index != active_touch:
			return

		if not event.pressed:

			if is_dragging:
				_on_drag_finished(event)
			else:
				clicked.emit()

			active_touch = -1
			is_dragging = false

			get_viewport().set_input_as_handled()


func _on_drag_started(_event: InputEventScreenDrag) -> void:
	pass


func _on_drag(_event: InputEventScreenDrag) -> void:
	pass


func _on_drag_finished(_event: InputEventScreenTouch) -> void:
	pass
