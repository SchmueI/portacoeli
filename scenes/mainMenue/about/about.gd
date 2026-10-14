extends GameBase

var TEXT = preload("res://assets/text/interface/mainMenue/mainMenue.gd").new().about

func _ready() -> void:
	lang = get_parent().lang
	$Text/Publisher.text = TEXT [lang] ["publisher"]
	$Text/Credits.text  = TEXT [lang] ["credits"]

func _on_button_back_clicked() -> void:
	var Level : PackedScene = load("res://scenes/mainMenue/mainMenue.tscn")
	var level = Level.instantiate()
	get_parent().add_child(level)
	queue_free()
