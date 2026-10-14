class_name TutorialController
extends Node


@export var popup_controller: PopupController
@export var movement_controller: MovementController
@export var highlight_controller: HighlightController

@export var herbarium: herbariumgame

var steps : Array[Dictionary]
var index : int = 0

var heavy = true
var savemanager = SaveManager.new()

func _ready() -> void:
	
	# Das Tutorial greift auf Instanzen des Herbariums zu, weshalb das Herbarium
	# erst vollständig initialisiert sein sollte
	var savegame = savemanager.load_specific("games", herbarium.standardSettings)
	if not savegame["herbarium"]["tutorial_completed"]:
		herbarium.game_loaded.connect(open_tutorial)
	else:
		herbarium.game_loaded.connect(start_game)
	
func open_tutorial() -> void:
	steps = load_data()
	
	# Deaktiviere Touch auf Herbarium-Elementen
	herbarium.toggle_scene_touch(false)
	
	# Willkommens-Popup mit Abfrage, ob ein Tutorial erforderlich ist.
	var popup = popup_controller.init_popup(
		steps[index]["Headline"],
		steps[index]["Text"],
		{
			"heavy"			: true,
			"timed"			: false,
			"conditional"	: true,
			"pos"			: Vector2(0,0),
			"scale"			: Vector2(1,1)
		}
	)
	
	popup.closed.connect(start_game)
	popup.next.connect(step.bind(popup, true))
	popup.previous.connect(step.bind(popup, false))
	
	popup.toggle_ui()
	popup.previous_button_visible(false)

func load_data() -> Array:
	var lang = herbarium.lang
	var DATA = preload("res://assets/text/levels/herbarium/tutorial.gd").new().data
	var data : Array[Dictionary]

	
	for i in range(DATA.size()):
		data.append(DATA[str(i)][lang])
	return data

func start_game() -> void:
	restore_highlighting()
	savemanager.modify_data({"games":{"herbarium":{"tutorial_completed":true}}})
	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(func():
		show_herbs()
		herbarium.spawn_elements()
		herbarium.toggle_scene_touch(true)
	)
	timer.one_shot = true
	timer.start(0.8)
	
func step(popup:NotificationPopup, next:bool=true) -> void:	
	
	# Setze highlighting zurück
	restore_highlighting()
	
	# Blättere vor oder zurück
	if next: index = index+1
	else: index = index-1
	
	# Verstecke den Zurück-Knopf auf der ersten Seite
	if index > 0:
		popup.previous_button_visible(true)
	else:
		popup.previous_button_visible(false)
	
	if index < steps.size():
		apply_changes(popup)
	else:
		popup.close.emit()
	
func apply_changes(popup:NotificationPopup):
	# Referenziere die Textstellen im  Popup
	var headline : Label = popup.get_node("Headline")
	var text 	 : Label = popup.get_node("Text")
	
	if steps[index]["Heavy"]:
		# Wenn es ein großes Popup ist, dann werden die Daten in das vorhandene Popup geladen
		# Lade den Text aus dem Datensatz
		headline.text = steps[index]["Headline"]
		text.text	  = steps[index]["Text"]
		# Wenn dieses Popup derzeit vorübergehend minimiert ist, öffne es wieder
		if not steps[index]["Heavy"] == heavy:
			heavy = steps[index]["Heavy"]
			movement_controller.fade_element(
				popup,
				Vector2(0,0),
				0.8,
				Vector2(1,1),
			)
		
		# Hebe ggf ein UI Element hervor.
		if not steps[index]["Highlight"] == null:
			highlight_element(steps[index]["Highlight"])
		
	else:
		if not steps[index]["Heavy"] == heavy: 
			heavy = steps[index]["Heavy"]
			# andernfalls wird dieses Popup vorübergehend minimiert und ein anderes geöffnet
			
			movement_controller.fade_element(
				popup, 
				Vector2(-50,-50),
				 0.8
			)
			
			scene_step(popup)

func highlight_element(element_name:String) -> void:
	var element = Node2D
	var pos = Vector2(0,0)
	if element_name == "box":
		element = herbarium.get_node("SEARCHBOX")
		pos = Vector2(500, 500)
	elif element_name == "herbarium":
		element = herbarium.get_node("ButtonBook")
		pos = Vector2(650, 500)
	elif element_name == "reload":
		element = herbarium.get_node("ButtonReload")
		pos = Vector2(650, 450)
	elif element_name == "check":
		element = herbarium.get_node("ButtonCheck")
		pos = Vector2(650, 500)
	elif element_name == "all":
		pass
	else:
		return
		
	if not element_name == "all":
		process_highlight(element, {"pos":pos})
	else:
		element = herbarium.get_node("SEARCHBOX")
		pos = Vector2(900, 500)
		process_highlight(element, {"pos":pos, "scl":0.25})
		
		
		element = herbarium.get_node("ButtonBook")
		pos = Vector2(400, 400)
		process_highlight(element, {"pos":pos, "scl":0.2})
		
		
		element = herbarium.get_node("ButtonReload")
		pos = Vector2(650, 475)
		process_highlight(element, {"pos":pos, "scl":0.1})
		
		
		element = herbarium.get_node("ButtonCheck")
		pos = Vector2(400, 550)
		process_highlight(element, {"pos":pos, "scl":0.2})

func process_highlight(element:Node2D, options:Dictionary={}) -> void:
	
	if options.has("pos"):
		var pos : Vector2 = options.get("pos")
		highlight_controller.highlight_element(element)
		movement_controller.move_element(
			element,
			pos,
			0.7
		)
	if options.has("scl"):
		var scl : float = options.get("scl")
		highlight_controller.scale_element(element, scl)
		
func restore_highlighting() -> void:
	var elements = [
		herbarium.get_node("SEARCHBOX"),
		herbarium.get_node("ButtonBook"),
		herbarium.get_node("ButtonReload"),
		herbarium.get_node("ButtonCheck")
	]
	var positions = [
		herbarium.pos_box,
		herbarium.pos_book,
		herbarium.pos_reload,
		herbarium.pos_check
	]
	var z = [
		herbarium.z_box,
		herbarium.z_book,
		herbarium.z_reload,
		herbarium.z_check
	]
	var scl = [
		herbarium.scl_box,
		herbarium.scl_book,
		herbarium.scl_reload,
		herbarium.scl_check
	]
	var i = 0
	for e in elements:
		movement_controller.move_element(e, positions[i], 0.7)
		highlight_controller.scale_element(e, scl[i][0])
		e.z_index = z[i]
		i = i+1
	pass
	
func scene_step(tutorial:NotificationPopup) -> void:
	var scene_popup = popup_controller.init_popup(
		steps[index]["Headline"],
		steps[index]["Text"],
		{
			"timed":false
		}
	)
	scene_popup.touch_enabled = false
	scene_popup.closed.connect(step.bind(tutorial))
	
	if steps[index]["Highlight"] == "parts":
		move_parts(scene_popup)
	
func move_parts(popup:NotificationPopup) -> void:
	herbarium.spawn_elements()
	for child in herbarium.herbs.get_children():
		child.touch_enabled = true
		child.moved.connect(part_moved.bind(popup))

func part_moved(popup:NotificationPopup) -> void:
	for child in herbarium.herbs.get_children():
		child.moved.disconnect(part_moved)
		movement_controller.move_element(
			child,
			herbarium.inipos,
			0.5
		)
		
	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(func():
		timer.queue_free()
		hide_herbs()
		popup.close.emit()
	)
	timer.one_shot = true
	timer.start(0.5)

func hide_herbs() -> void:
	for child in herbarium.herbs.get_children():
		highlight_controller.scale_element_immediately(child, 0)
		
func show_herbs() -> void:
	for child in herbarium.herbs.get_children():
		highlight_controller.scale_element_immediately(child, child.intScale)
