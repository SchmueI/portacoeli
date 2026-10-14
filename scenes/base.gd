extends GameBase

func _ready() -> void:
	var savegame = SaveManager.new()
	var settings = savegame.load_specific("settings", {"lang":"ger"})
	if settings.has("lang"):
		lang = settings["lang"]
	else:
		print ("No language specified, using german as language instead.")
		lang = "ger"
		
	var Level : PackedScene = load("res://scenes/mainMenue/mainMenue.tscn")
	var level = Level.instantiate()
	self.add_child(level)
