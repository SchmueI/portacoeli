class_name herbariumgame
extends Herbarium

var HERBS := []
var triangulation	: PackedInt32Array
var inipos			: Vector2 			= Vector2(182,614)

var pos_box:Vector2
var pos_book:Vector2
var pos_reload:Vector2
var pos_check:Vector2

var z_box		: int
var z_book		: int
var z_reload	: int
var z_check		: int

var scl_box		: Vector2
var scl_book	: Vector2
var scl_reload	: Vector2
var scl_check	: Vector2

var boxpath		: String

var standardSettings := {
	"herbarium":{
		"assembled":{},
		"points": 0,
		"tutorial_completed":false
	}
}

@onready var spawn_polygon: Polygon2D = $SpawnArea
@onready var herbs: Node2D = $Herbs
@onready var herbariumcontroller := $HerbariumController

signal game_loaded

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	lang = get_parent().lang	
	
	pos_book 	= $ButtonBook	.position
	pos_reload 	= $ButtonReload	.position
	pos_check 	= $ButtonCheck	.position
	
	z_book 		= $ButtonBook	.z_index
	z_reload 	= $ButtonReload	.z_index
	z_check 	= $ButtonCheck	.z_index
	
	scl_book	= $ButtonBook	.scale
	scl_reload	= $ButtonReload	.scale
	scl_check	= $ButtonCheck	.scale
	
	init_level()
	
	game_loaded.emit()
	
	

func init_level() -> void:
	
	# loading up level data
	herbariumcontroller.next_level()
	
	# loading up search box
	var Box := load ("res://scenes/herbarium/searchbox/searchbox.tscn")
	var box = Box.instantiate()
	box.position = Vector2(1046,150)
	box.scale	 = Vector2(0.3, 0.3)
	box.herbariumcontroller = $HerbariumController
	add_child(box)
	box.name	= &"SEARCHBOX"
	boxpath		= box.get_path()
	scl_box		= box			.scale
	z_box 		= box			.z_index
	pos_box 	= box			.position
	
	#instantiate spawn area for elements
	triangulation = Geometry2D.triangulate_polygon(
		spawn_polygon.polygon
	)
	var elements = HERBS.duplicate()
	load_elements(elements)
	

func _on_check_clicked() -> void:
	var goal = herbariumcontroller.get_goal()
	var groupname = goal["name"]
	var parts : Array[String] = []
	for part in goal["parts"]:
		parts.append(part)
		
	if CombinationChecker.check_valid_combination(groupname, parts, herbs.get_children()):
		_handle_correct_solution(groupname)
	else:
		_handle_incorrect_solution()
		
func _handle_correct_solution(groupname) -> void:
	
	herbariumcontroller.score(groupname)
	
	var entities = []
	var Nodes
	for herb in HERBS:
		if not herb["name"] == groupname:
			entities.append(herb["name"])
	for herb in entities:
		Nodes = get_tree().get_nodes_in_group(herb)
		for node in Nodes:
			node.queue_free()
			
	Nodes = get_tree().get_nodes_in_group(groupname)
	for node in Nodes:
		var pos = inipos
		var time = RNG.randf_range(0.7,0.9)
		$MovementController.move_element(node, pos, time)
	
	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(func():
		timer.queue_free()
		next_game()
	)
	timer.one_shot = true
	timer.start(0.9)
	
func next_game():
	get_node(boxpath).queue_free()
	remove_elements()
	init_level()
	spawn_elements()

func _handle_incorrect_solution() -> void:
	$PopupController.init_popup(POPUPS.wrong[lang]["headline"], POPUPS.wrong[lang]["text"])

func _on_button_book_clicked() -> void:
	var Book : PackedScene = load("res://scenes/herbarium/book/book.tscn")
	var book = Book.instantiate()
	book.closed.connect(_on_book_closed)
	book.lang = lang
	book.herbariumcontroller = $HerbariumController
	toggle_scene_touch(false)
	get_parent().add_child(book)

func _on_book_closed() -> void:
	toggle_scene_touch(true)
	
func _on_button_reload_clicked() -> void:
	shuffle()
		
		

func shuffle() -> void:
	var elements = herbs.get_children()
	var sticked = CombinationChecker.get_elements_in_target_area($Target/TargetArea, elements)
	for s in sticked:
		elements.erase(s)
	for child in elements:
		var pos = get_random_spawn_position(spawn_polygon, [$Target/Boundaries])
		var time = RNG.randf_range(0.5,0.9)
		$MovementController.move_element(child, pos, time)
		
func shuffle_all() -> void:
	for child in herbs.get_children():
		var pos = get_random_spawn_position(spawn_polygon, [$Target/Boundaries])
		var time = RNG.randf_range(0.5,0.9)
		$MovementController.move_element(child, pos, time)
	
func _on_button_back_clicked() -> void:
	var Level : PackedScene = load("res://scenes/levelSelector/levelSelector.tscn")
	var level = Level.instantiate()
	get_parent().add_child(level)
	queue_free()

func spawn_elements() -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(func():
		shuffle_all()
		timer.queue_free()
	)
	timer.one_shot = true
	timer.start(0.5)

func remove_elements() -> void:
	for child in herbs.get_children():
		child.queue_free()
	
func toggle_scene_touch(state:bool=false) -> void:
	var ui_elements = get_tree().get_nodes_in_group("UI")
	for element in ui_elements:
		element.touch_enabled = state
	
	for child in herbs.get_children():
		child.touch_enabled = state
	
func load_elements(elements : Array):
	# elements = [{}]
	
	for element in elements:
		var NAME = element.get("name")
		var PARTS = element.get("parts")
		for PART in PARTS:
			var Part = PARTS[PART].instantiate() as DragableObject
			Part.add_to_group(NAME)
			Part.add_to_group(PART)
			
			Part.scale = Vector2(Part.intScale, Part.intScale)
			
			Part.position = inipos
			
			Part.boundary_mode = DragableObject.BoundaryMode.KEEP_INSIDE
			
			herbs.add_child(Part)
