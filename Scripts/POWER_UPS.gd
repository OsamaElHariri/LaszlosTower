extends Node2D

signal power_ups_changed
signal selected_index_changed

var _collected_power_ups = []

var selected_power_up_index = -1 setget set_selected_power_up_index

var empty_power_up = load('res://Scenes/PowerUps/EmptyPowerUp.tscn')

func set_selected_power_up_index(index):
	if get_selected_power_up().active:
		return
	if selected_power_up_index == index:
		selected_power_up_index = -1
	else:
		selected_power_up_index = index
	emit_signal('selected_index_changed')

func can_select_index(index):
	return is_power_up(index) && !_collected_power_ups[index].depleted

func is_power_up(index):
	if index < 0 || index >= _collected_power_ups.size():
		return false
	return true

func is_depleted(index):
	if !is_power_up(index):
		return false
	return _collected_power_ups[index].depleted

func add_power_up(power_up):
	_collected_power_ups.append(power_up)
	emit_signal('power_ups_changed')

func pop_tail(number_of_power_ups):
	var size_after_popping_power_ups = _collected_power_ups.size() - number_of_power_ups
	if selected_power_up_index >= size_after_popping_power_ups:
		deactivate_selected()
	emit_power_ups_destroyed_from_index(size_after_popping_power_ups)
	_collected_power_ups.resize(max(0, size_after_popping_power_ups))
	clean_up_after_remove()
	

func pop_index(index):
	if index >= _collected_power_ups.size() || index < 0:
		return
	if selected_power_up_index >= index:
		deactivate_selected()
	emit_power_ups_destroyed_from_index(index)
	_collected_power_ups.resize(index)
	clean_up_after_remove()

func deactivate_selected():
	if is_power_up(selected_power_up_index):
		_collected_power_ups[selected_power_up_index].deactivate()

func emit_power_ups_destroyed_from_index(index):
	while index < _collected_power_ups.size():
		if index >= 0:
			EMITTER.emit('power_up_destroyed', {
				'pos': VARIABLES.current_tower_position,
				'type': _collected_power_ups[index].type
			})
		index += 1

func clean_up_after_remove():
	selected_power_up_index = -1
	emit_signal('power_ups_changed')

func get_selected_power_up():
	if selected_power_up_index >= _collected_power_ups.size() || selected_power_up_index < 0:
		return empty_power_up.instance()
	return _collected_power_ups[selected_power_up_index]
