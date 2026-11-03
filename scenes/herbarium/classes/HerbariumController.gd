class_name HerbariumController
extends Node

var goal : Dictionary = {}
var assembled : Array[String]

var savemanager = SaveManager.new()
@export var herbarium:herbariumgame
@export var parts:Node2D
@export var target:Node2D
	
func load_data() -> Dictionary:
	return savemanager.load_specific("games", herbarium.standardSettings)

func save_data(data:Dictionary) -> void:
	savemanager.modify_data({"games":data})

func score(plant:String) -> void:
	register_assembly(plant)
	add_points(1)

func register_assembly(plant:String) -> void:
	var data = load_data()
	if data["herbarium"]["assembled"].has(plant): 
		data["herbarium"]["assembled"][plant] += 1
	else:
		data["herbarium"]["assembled"][plant] = 1
	save_data(data)
	
func add_points(q:int = 0) -> void:
	var data = load_data()
	data["herbarium"]["points"] += q
	save_data(data)

func get_assemblies(plant:String) -> int:
	var data = load_data()
	if data["herbarium"]["assembled"].has(plant):
		return int(data["herbarium"]["assembled"][plant])
	else:
		data["herbarium"]["assembled"][plant] = 0
		save_data(data)
		return 0
		
func get_points() -> int:
	var data = load_data()
	return int(data["herbarium"]["points"])

func create_herblist(maxHerbs:int=3) -> Array[Dictionary]:
	var output : Array[Dictionary]
	var herblist = herbarium.HerbList.duplicate()
	maxHerbs = min(maxHerbs, herblist.size())
	for n in range (maxHerbs):
		var i = herbarium.RNG.randi_range(0, herblist.size()-1)
		output.append(herblist[i])
		herblist.remove_at(i)
	return output
	
func select_goal(herblist) -> Dictionary:
	var i = herbarium.RNG.randi_range(0, herblist.size()-1)
	return herblist[i]

func next_level() -> void:
	var herblist = create_herblist(2)
	goal = select_goal(herblist)
	herbarium.HERBS = herblist
	assembled = []

func connect_part_signals() -> void:
	for child in parts.get_children():
		child.moved.connect(
			func():
				part_moved(child)
		)
	
func part_moved(part):
	var targetArea = target.get_child(1)
	var goalname : String = goal["name"]
	var insertion = CombinationChecker.check_valid_insertion(part, targetArea, goalname)
	if insertion == true: 
		handle_correct_insertion(part)
		check_assembly()
	if insertion == false: handle_incorrect_insertion(part)

func get_part_name(part):
	for p in goal["parts"]:
		if part.is_in_group(p): return p
	return null
	
func handle_correct_insertion(part):
	var part_name = get_part_name(part)
	if not part_name in assembled:
		assembled.append(part_name)
	print (assembled)
	
func handle_incorrect_insertion(part):
	pass
	
func check_assembly():
	var goalparts := []
	for p in goal["parts"]:
		goalparts.append(p)
	goalparts.sort()
	assembled.sort()
	if goalparts == assembled:
		herbarium._handle_correct_solution(goal["name"])
	
func maximum_information(herb:String) -> int:
	var output : int = 0
	var assemblies = int(get_assemblies(herb))
	
	if assemblies-1 < 0: assemblies = 0
	else: assemblies -= 1
	
	output = int(assemblies)*3
	return output

func get_available_information(herb:Dictionary) -> Dictionary:
	var lang = herbarium.lang
	var maximum : int = maximum_information(herb["name"])
	var i : int = 0
	var outp : Dictionary = {}
	var herb_text = herb["info"][lang]
	for information in herb_text:
		if not i > maximum:
			outp.merge({information:herb_text[information]})
			i += 1

	return outp

func check_modulation(herb:String, Part):
	var assemblies = int(get_assemblies(herb))
	if assemblies == 0: Part.modulate = Color.BLACK

func get_available_herbs() -> Array:
	return herbarium.HerbList

func get_goal() -> Dictionary:
	return goal
