extends GameBase

var current_herb := {}
var selfScale = 1.5
var offset = 130
var herbs = []

var index = -1


var herbariumcontroller : HerbariumController

signal closed

@onready var Title 			:= $Book/Text/Title
@onready var Category 		:= $Book/Text/Category
@onready var Content 		:= $Book/Text/Content
@onready var HerbContainer	:= $Book/Herbs
	
func _ready() -> void:	
	current_herb = herbariumcontroller.get_goal()
	herbs = herbariumcontroller.get_available_herbs()
	index = herbs.find(current_herb)
	
	draw(current_herb)
	
func draw(herb) -> void:
		
	for element in HerbContainer.get_children():
		element.queue_free()
	
	if herb.has("set"):
		var part = herb["set"]
		var part_instance = part.instantiate()
		part_instance.position = Vector2(800, 300)
		part_instance.set_script(null)
		herbariumcontroller.check_modulation(herb["name"], part_instance)
		HerbContainer.add_child(part_instance)
	
	else:
		var i : int = 0
		for part in herb["parts"]:
			var part_scene = herb["parts"][part]
			var part_instance = part_scene.instantiate()
			part_instance.scale = Vector2(part_instance.intScale*selfScale, part_instance.intScale*selfScale)
			part_instance.position = Vector2(800, 180+(i*offset))
			part_instance.set_script(null)
			herbariumcontroller.check_modulation(herb["name"], part_instance)
			HerbContainer.add_child(part_instance)
			i += 1
		
	var infos = herbariumcontroller.get_available_information(herb)
	
	Title.text = infos["Name"]
	Category.text = ""
	Content.text = ""
	for info in infos:
		if not info == "Name":
			Category.text = Category.text + String(info) + "\n"
			Content.text  = Content.text + String(infos[info]) + "\n"
			for character in infos[info]: 
				if character == "\n": Category.text = Category.text + "\n"			

func _on_page_forward_clicked() -> void:
	if index+1 <= herbs.size()-1:
		index += 1
	else:
		index = 0
	current_herb = herbs[index]
	draw(current_herb)

func _on_page_back_clicked() -> void:
	if index-1 >= 0:
		index -= 1
	else:
		index = herbs.size()-1
		
	current_herb = herbs[index]
	draw(current_herb)


func _on_button_back_clicked() -> void:
	closed.emit()
	queue_free()
