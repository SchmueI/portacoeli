class_name CombinationChecker
extends RefCounted

static func check_valid_combination( group_name: String, parts: Array[String], elements: Array[Node]) -> bool:

	var connected_parts := get_connected_parts(
		group_name,
		parts,
		elements
	)

	var expected_parts := parts.duplicate()

	connected_parts.sort()
	expected_parts.sort()

	return connected_parts == expected_parts

static func get_connected_parts( group_name: String, parts: Array[String], elements: Array[Node]) -> Array[String]:

	var joints: Array[Area2D] = []
	var areas: Array[Area2D] = []
	var connected_parts: Array[String] = []

	for child in elements:
		if not child.is_in_group(group_name):
			continue
			
		var joint := child.get_node_or_null("JointArea") as Area2D
		if joint != null:
			joints.append(joint)
			
		var area := child.get_node_or_null("TouchArea") as Area2D
		if area != null:
			areas.append(area)

	for joint in joints:
		for area in areas:
			if not joint.overlaps_area(area):
				continue

			var joint_owner := joint.get_parent()
			var area_owner := area.get_parent()
			for part in parts:
				part = str(part)
				if area_owner.is_in_group(part):
					if not joint_owner.is_in_group(part):
						if part not in connected_parts:
							connected_parts.append(part)
				elif joint_owner.is_in_group(part):
					if not area_owner.is_in_group(part):
						if part not in connected_parts:
							connected_parts.append(part)

	return connected_parts
	
static func get_elements_in_target_area(
	target_area: Area2D,
	elements: Array[Node]
) -> Array[Node2D]:
	var elements_in_target: Array[Node2D] = []

	for element in elements:
		var touch_area := element.get_node_or_null("TouchArea") as Area2D

		if touch_area == null:
			continue

		if touch_area.overlaps_area(target_area):
			elements_in_target.append(element as Node2D)

	return elements_in_target
