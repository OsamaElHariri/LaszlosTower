var section_scene = load('res://Scenes/TowerSection/TowerSection.tscn')
var power_up_scene
var type
var limit
	
var current_dispensed = 0
	
func _init(power_up_type, max_number_of_section):
	type = power_up_type
	power_up_scene = TOWER_TYPES.type_scenes[power_up_type]
	limit = max_number_of_section
	EMITTER.connect('power_up_destroyed', self, 'section_destroyed')
	
func can_dispense():
	return current_dispensed < limit
	
func dispense():
	current_dispensed += 1
	var new_section = section_scene.instance()
	new_section.set_power_up_tscn_and_power_up(power_up_scene)
	return new_section
	
func section_destroyed(section):
	if section.type == type:
		current_dispensed -= 1
