class_name Previews
extends RefCounted

static var PREVIEWS : Dictionary = {
	"herbarium":"res://scenes/levelSelector/previews/herbarium_preview.tscn"
}

func get_preview(gameID:String) -> String:
	return PREVIEWS[gameID]
