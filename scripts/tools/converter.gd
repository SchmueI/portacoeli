class_name converter
extends RefCounted

static func string_to_vector2(text: String) -> Vector2:
	var values := text.trim_prefix("(").trim_suffix(")").split(",")

	return Vector2(
		values[0].strip_edges().to_float(),
		values[1].strip_edges().to_float()
	)
