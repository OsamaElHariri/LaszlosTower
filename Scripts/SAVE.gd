extends Node

var save_location = 'res://LevelSave/save.json'

func get_saved_levels ():
	var file = File.new()
	if  !file.file_exists(save_location):
		return []
		
	
	file.open(save_location, File.READ)
	var level_dict = parse_json(file.get_as_text())
	file.close()
	
	if !level_dict.has('levels'):
		return []
	var levels_array = floats_to_ints(level_dict.levels)
	return levels_array

func floats_to_ints(levels_array):
	var index = 0
	while index < levels_array.size():
		levels_array[index] = int(levels_array[index])
		index += 1
	return levels_array

func save_levels (level_array):
	var level_dict = {
		'levels': level_array
	}
	
	var file = File.new()
	file.open(save_location, File.WRITE)
	file.store_line(to_json(level_dict))
	file.close()

