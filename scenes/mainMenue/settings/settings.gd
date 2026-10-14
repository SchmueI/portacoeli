extends GameBase

var TEXT = preload("res://assets/text/interface/mainMenue/mainMenue.gd").new().settings

func _ready() -> void:
	lang = get_parent().lang
	setup()
	pass

func _on_button_back_clicked() -> void:
	var Level : PackedScene = load("res://scenes/mainMenue/mainMenue.tscn")
	var level = Level.instantiate()
	get_parent().add_child(level)
	queue_free()

func change_lang(language:String) -> void:
	get_parent().lang = language
	lang = language
	setup()
	
	var savemanager = SaveManager.new()
	savemanager.modify_data({
		"settings":{
			"lang":language
		}
	})

func _on_ger_button_clicked() -> void: change_lang("ger")

func _on_eng_button_clicked() -> void: change_lang("eng")

func _on_fr_button_clicked() -> void: change_lang("fr")

func setup() -> void:
	$Text/Title.text 	= TEXT [lang] ["title"]
	$Text/Language.text = TEXT [lang] ["language"]
	$Text/DelSave.text	= TEXT [lang] ["delSaveButton"]

func toggle_touch(state:bool) -> void:
	var ui_elements = get_tree().get_nodes_in_group("UI")
	for element in ui_elements:
		element.touch_enabled = state

func _on_delete_button_clicked() -> void:
	var savemanager = SaveManager.new()

	toggle_touch(false)
	
	var popup = $PopupController.init_popup(TEXT[lang]["delSaveButton"], 
	TEXT[lang]["delSaveText"],
	{"timed":false,
	"heavy":true,
	"scale":Vector2(0.95,0.95)})
	
	popup.toggle_ui(true)
	
	popup.next.connect(func():
		savemanager.delete_savestate()
		$PopupController.close_popup(popup)
		change_lang("ger")
		)
	popup.previous.connect($PopupController.close_popup.bind(popup))
	popup.closed.connect(toggle_touch.bind(true))

	
