extends Node2D	

var savemanager = SaveManager.new()
var RNG = RandomNumberGenerator.new()
var TEXT = preload("res://assets/text/interface/mainMenue/mainMenue.gd").new().level_selector
var lang = "ger"

func _ready() -> void:
	lang = savemanager.load_specific("settings", {"lang":"ger"}).get("lang", "ger")
	var mapposition = converter.string_to_vector2(
		savemanager.load_specific(
			"mapposition", 
			str(Vector2(-990, -575))
		)
	)
	$Map.position = mapposition
	RNG.randomize()
	check_init()
	
func check_init():
	if not savemanager.load_specific("mapmoved", false):
		slide_map()
		open_hint_popup()
		savemanager.modify_data({"mapmoved":true})
		
func slide_map():
	var pos = $Map.position
	var fx = -1
	var fy = -1
	if randf_range(-1, 1) > 0: fx = 1
	if randf_range(-1, 1) > 0: fy = 1
	var newpos = Vector2(
		pos[0]+(fx*randf_range(100, 250)), 
		pos[1]+(fy*randf_range(100, 250))
	)
	
	$MovementController.move_element($Map, newpos, 1.5)

func open_hint_popup():
	$PopupController.init_popup(
	TEXT[lang]["map"], 
	TEXT[lang]["hint"],
	{"timed":true,
	"heavy":false,
	"duration": 6.5,
	"scale":Vector2(0.35, 0.35)})

func open_implementation_missing_popup():
	$PopupController.init_popup(
	TEXT[lang]["missing"], 
	TEXT[lang]["missing_text"])
	
func open_preview(gameID:String):
	if $PopupController.heavy_opened(): return
	var popup : NotificationPopup = $PopupController.init_popup(
		TEXT[lang][gameID]["title"],
		TEXT[lang][gameID]["description"],
		{
			"pos":Vector2(520, 270),
			"sourcePos":Vector2(1290, 730),
			"heavy":true,
			"timed":false,
			"scale":Vector2(0.6, 0.6)
		}
	)
	popup.previous_button_visible(false)
	var startbutton = popup.get_next_button()
	startbutton.position = Vector2(660,650)
	startbutton.clicked.connect(func():launch_game("res://scenes/herbarium/herbarium.tscn"))

func launch_game(scene:String):
	var sc : PackedScene = load(scene)
	var instance = sc.instantiate()
	get_parent().add_child(instance)
	queue_free()

func _on_button_back_clicked() -> void:
	launch_game("res://scenes/mainMenue/mainMenue.tscn")

func _on_herbarium_button_clicked() -> void:
	open_preview("herbarium")

func _on_map_moved() -> void:
	savemanager.modify_data({"mapposition":$Map.position})


func _on_apple_button_clicked() -> void:
	open_implementation_missing_popup()


func _on_forrest_button_clicked() -> void:
	open_implementation_missing_popup()


func _on_river_button_clicked() -> void:
	open_implementation_missing_popup()


func _on_sheep_button_clicked() -> void:
	open_implementation_missing_popup()
