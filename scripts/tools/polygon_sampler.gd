class_name PolygonSampler
extends RefCounted


class Triangle:
	var p1: Vector2
	var p2: Vector2
	var p3: Vector2

	func _init(
		point1: Vector2,
		point2: Vector2,
		point3: Vector2
	) -> void:
		p1 = point1
		p2 = point2
		p3 = point3


	func get_area() -> float:
		return 0.5 * abs(
			p1.x * (p2.y - p3.y)
			+ p2.x * (p3.y - p1.y)
			+ p3.x * (p1.y - p2.y)
		)


	func get_random_point(rng: RandomNumberGenerator) -> Vector2:
		var a := rng.randf()
		var b := rng.randf()

		if a > b:
			var temp := a
			a = b
			b = temp

		return (
			p1 * a
			+ p2 * (b - a)
			+ p3 * (1.0 - b)
		)


static func get_random_point_in_polygon(
	polygon: PackedVector2Array,
	rng: RandomNumberGenerator
) -> Vector2:

	var triangulation := Geometry2D.triangulate_polygon(polygon)

	return get_random_point_in_triangulated_polygon(
		polygon,
		triangulation,
		rng
	)


static func get_random_point_in_triangulated_polygon(
	polygon: PackedVector2Array,
	triangle_points: PackedInt32Array,
	rng: RandomNumberGenerator
) -> Vector2:

	if triangle_points.is_empty():
		push_error("Polygon konnte nicht trianguliert werden.")
		return Vector2.ZERO

	var triangle_weights := PackedFloat32Array()
	var triangles: Array[Triangle] = []

	var index := 0

	while index < triangle_points.size():
		var triangle := Triangle.new(
			polygon[triangle_points[index]],
			polygon[triangle_points[index + 1]],
			polygon[triangle_points[index + 2]]
		)

		triangles.append(triangle)
		triangle_weights.append(triangle.get_area())

		index += 3

	var selected_index := rng.rand_weighted(triangle_weights)

	return triangles[selected_index].get_random_point(rng)

static func get_random_point_excluding(
	spawn_area: Polygon2D,
	excluded_areas: Array[Polygon2D],
	rng: RandomNumberGenerator
) -> Vector2:

	for attempt in range(100):

		var local_point: Vector2 = get_random_point_in_polygon(
			spawn_area.polygon,
			rng
		)

		var global_point: Vector2 = spawn_area.to_global(local_point)

		var valid: bool = true

		for excluded_area in excluded_areas:

			var excluded_local_point: Vector2 = excluded_area.to_local(
				global_point
			)

			if Geometry2D.is_point_in_polygon(
				excluded_local_point,
				excluded_area.polygon
			):
				valid = false
				break

		if valid:
			return global_point

	push_warning("Kein gültiger Spawnpunkt gefunden.")
	return Vector2.ZERO
