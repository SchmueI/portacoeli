class_name HerbView
extends Node2D

@export var stem		:	Texture2D
@export var bloom		:	Texture2D
@export var leaves		:	Texture2D
@export var stem_bloom	:	Texture2D
@export var stem_leaves	:	Texture2D
@export var bloom_leaves:	Texture2D
@export var complete	:	Texture2D

@export var intScale	:	float		=	0.1

@onready var sprite		:	Sprite2D	=	$Sprite2D

static var COMPLETE := {"stem":true, "bloom":true, "leaves":true}
var initState : Dictionary

func _ready() -> void:
	set_state()

func get_texture(state:Dictionary) -> Texture2D:
	var has_stem:bool = state.get("stem", false)
	var has_bloom:bool = state.get("bloom", false)
	var has_leaves:bool = state.get("leaves", false)
	
	match [has_stem, has_bloom, has_leaves]:
		[true, true, true]:
			return complete

		[true, true, false]:
			return stem_bloom

		[true, false, true]:
			return stem_leaves

		[false, true, true]:
			return bloom_leaves

		[true, false, false]:
			return stem

		[false, true, false]:
			return bloom

		[false, false, true]:
			return leaves

		_:
			return null
	
	
func set_state(state:Dictionary=initState) -> void:
	var texture : Texture2D = get_texture(state)
	
	if not texture == null: 
		sprite.visible = true
		sprite.texture = texture
	else:
		sprite.visible = false 
		
func init_state(state:Dictionary) -> void:
	initState = state
