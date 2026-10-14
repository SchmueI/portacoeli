class_name PopupController
extends Node

var iniscale : Vector2 = Vector2(0.3,0.3)
var inispeed : float   = 0.8

@export var inipos: Vector2 = Vector2(10,10)
@export var maxPopup : int = 3

var open_popups := []
var popup_queue := []

var popup_tweens := {}

func init_popup(
	headline	: String, 
	text		: String, 
	options		:= {}
) -> NotificationPopup:
	
	var pos 		: Vector2 	= options.get("pos", 		inipos)
	var duration 	: float		= options.get("duration", 	5)
	var timed 		: bool 		= options.get("timed", 		true)
	var heavy 		: bool 		= options.get("heavy", 		false)
	var scl  		: Vector2	= options.get("scale",		iniscale)

	var POPUP:PackedScene
	
	# Wähle den Popup Typ
	if not heavy: POPUP = load("res://scenes/interface/Popup.tscn")
	else: POPUP = load("res://scenes/interface/HeavyPopup.tscn")
	var popup = POPUP.instantiate()
	
	# Startposition für die Animation
	popup.scale = Vector2(0,0)
	popup.position = Vector2(0,0)
	
	# verknüpfe listener zum schließen
	popup.close.connect(_on_close_request.bind(popup))
	
	# Daten übergeben
	popup.get_node("Headline").text = headline
	popup.get_node("Text").text = text	
	
	# Popup zum Scene-Tree hinzufügen
	add_child(popup)
	
	if timed:		
		# Popup in Array übertragen
		popup_queue.append({
			"popup":popup,
			"pos":pos,
			"duration":duration,
			"scale":scl
			})

		update_queue()
	else:
		open_popup(popup, pos, scl)
	
	return popup

func update_queue():
	var QUEUE = popup_queue.duplicate()
	for popup in QUEUE:
		if open_popups.size() < maxPopup:
			var POPUP	= popup["popup"]
			var POS		= popup["pos"]
			var DURATION= popup["duration"]
			var SCALE	= popup["scale"]
			open_popups.append(POPUP)
			open_timed_popup(POPUP, POS, DURATION, SCALE)
			popup_queue.erase(popup)
			
	var index = 0
	for popup in open_popups:
		var pos = inipos
		var relpos : Vector2 = Vector2(pos[0], (pos[1]+(75*index)))
		if not popup.position == relpos: move_popup(popup, relpos)
		index = index+1

func open_timed_popup(
	popup		: Node,
	pos			: Vector2,
	duration	: float, 
	popscale	: Vector2
	) -> void:
	
	var tween = create_tween()
	popup_tweens[popup] = tween
	tween.set_trans(Tween.TRANS_SINE)
	
	tween.tween_property(popup, "position", pos, inispeed)
	tween.parallel().tween_property(popup, "scale", popscale, inispeed)
	
	tween.tween_interval(duration)
	tween.tween_callback(
		func():
			popup_tweens.erase(popup)
			close_popup(popup)
	)
	
func open_popup(
	popup:	Node,
	pos:	Vector2,
	popscale: Vector2
) -> void:
	var tween = create_tween()
	popup_tweens[popup] = tween
	tween.set_trans(Tween.TRANS_SINE)
	
	tween.tween_property(popup, "position", pos, inispeed)
	tween.parallel().tween_property(popup, "scale", popscale, inispeed)
	
			
func close_popup(popup):
	open_popups.erase(popup)
	update_queue()
	popup.closed.emit()
	var tween = create_tween()
	tween.tween_property(popup, "position", Vector2(0,0), inispeed)
	
	tween.parallel().tween_property(popup, "scale", Vector2(0,0), inispeed)
	tween.tween_callback(popup.queue_free)
	
			
func move_popup(popup, pos):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(popup, "position", pos, inispeed)
	
func _on_close_request(popup):
	if popup_tweens.has(popup):
		var tween:Tween = popup_tweens[popup]
		tween.kill()
		popup_tweens.erase(popup)
	close_popup(popup)
	
