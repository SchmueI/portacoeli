extends GameBase

var goal := {}
var selfScale = 1.8
var offset = 200

var herbariumcontroller:HerbariumController

func _on_button_back_clicked() -> void:
	queue_free()
	
func _ready() -> void:
	lang = get_parent().lang
	goal = herbariumcontroller.get_goal()
	
	name = goal["info"][lang]["Name"]
	
	$Nametag.text = name
	
	if goal.has("set"):
		var part = goal["set"]
		var part_instance = part.instantiate()
		part_instance.position = Vector2(530, -230+offset)
		part_instance.scale = Vector2(part_instance.intScale, part_instance.intScale)
		part_instance.init_state(HerbView.COMPLETE)
		herbariumcontroller.check_modulation(goal["name"], part_instance)
		add_child(part_instance)
	
	else:
		var i : int = 0
		for part in goal["parts"]:
			var part_scene = goal["parts"][part]
			var part_instance = part_scene.instantiate()
			part_instance.scale = Vector2(part_instance.intScale*selfScale, part_instance.intScale*selfScale)
			part_instance.position = Vector2(530, -230+(i*offset))
			herbariumcontroller.check_modulation(goal["name"], part_instance)
			part_instance.set_script(null)
			add_child(part_instance)
			i += 1
