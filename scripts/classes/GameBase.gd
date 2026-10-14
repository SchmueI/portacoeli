class_name GameBase 
extends Node2D

const 	GAMESIZE	: Vector2 	= Vector2(1280,720)
const 	GAMERECT	: Rect2		= Rect2(Vector2.ZERO, GAMESIZE)
const	OFFSET		: int		= 100
var 	RNG			:			= RandomNumberGenerator.new()
var		lang		: String	= "ger"

func _ready() -> void:
	RNG.randomize()

func get_random_position(maxX = GAMESIZE[0], maxY = GAMESIZE[1]) -> Vector2:
	var x = RNG.randi_range(OFFSET, maxX-OFFSET)
	var y = RNG.randi_range(OFFSET, maxY-OFFSET)
	return Vector2(x,y)
	
	
func get_random_spawn_position(spawn_polygon, excluding:Array[Polygon2D]) -> Vector2:
	var point := PolygonSampler.get_random_point_excluding(
		spawn_polygon,
		excluding,
		RNG
	)

	return spawn_polygon.to_global(point)
