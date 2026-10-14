class_name HighlightController
extends Node

func highlight_element(element:Node2D, index:int=100):
	element.z_index = index

func scale_element(element:Node2D, scale:float):
	var tween = create_tween()
	tween.tween_property(element, "scale", Vector2(scale,scale), 0.3)

func scale_element_immediately(element:Node2D, scale:float):
	var tween = create_tween()
	tween.tween_property(element, "scale", Vector2(scale,scale), 0)
