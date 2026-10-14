class_name SaveManager
extends RefCounted

var path = "user://savegame.save"

func save_game(save:Dictionary = {}) -> bool:
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	if save_file == null: return false
	save_file.store_string(JSON.stringify(save))
	save_file.close()
	return true

func load_game() -> Dictionary:
	if not FileAccess.file_exists(path): 
		return {}
		
	var save_file = FileAccess.open(path, FileAccess.READ)
	if save_file == null: return {}
	var json_string = save_file.get_as_text()
	save_file.close()
		
	var json = JSON.new()
		
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		return {}
	
	var data = json.data
	if not data is Dictionary: 
		return {}
	
	return data

func merge_data(data: Dictionary, attributes: Dictionary) -> void:
	for key in attributes:
		if (
			data.has(key)
			and data[key] is Dictionary
			and attributes[key] is Dictionary
			):
				merge_data(
					data[key],
					attributes[key]
				)
		else:
			data[key] = attributes[key]

func modify_data(attributes:Dictionary) -> bool:	
	var data = load_game()
	merge_data(data, attributes)
	return save_game(data)
	
func load_specific(key:String, standard:Variant = null) -> Variant:
	var data = load_game()
	if data.has(key): return data[key]
	else:
		print (key+" Not found. Using standard value: "+str(standard)) 
		if not standard == null: modify_data({key:standard})
		return standard
		
func delete_savestate() -> void:
	save_game({})
