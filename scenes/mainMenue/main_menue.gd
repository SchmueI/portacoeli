extends GameBase

var TEXT = preload("res://assets/text/interface/mainMenue/mainMenue.gd").new().menue

func _ready() -> void:
	lang = get_parent().lang
	$Text/Start.text		= TEXT [lang] ["start"]
	$Text/Settings.text 	= TEXT [lang] ["settings"]
	$Text/About.text		= TEXT [lang] ["about"]
	$Text/Quit.text			= TEXT [lang] ["quit"]
	
	
	
func _on_start_game_clicked() -> void:
	var Level : PackedScene = load("res://scenes/levelSelector/levelSelector.tscn")
	var level = Level.instantiate()
	get_parent().add_child(level)
	queue_free()


func _on_about_clicked() -> void:
	var Level : PackedScene = load("res://scenes/mainMenue/about/about.tscn")
	var level = Level.instantiate()
	get_parent().add_child(level)
	queue_free()


func _on_settings_clicked() -> void:
	var Level : PackedScene = load("res://scenes/mainMenue/settings/settings.tscn")
	var level = Level.instantiate()
	get_parent().add_child(level)
	queue_free()
