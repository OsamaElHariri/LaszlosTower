extends Button

var level_order_index

func set_level_order_index(order_index):
	level_order_index = order_index
	connect('button_up', self, 'clicked')
	text = '{0}'.format([level_order_index + 1])
	
	if not LEVEL_TRANSITION.level_order[order_index] in LEVEL_TRANSITION.completed_levels:
		disabled = true

func clicked():
	LEVEL_TRANSITION.go_to_level_index(level_order_index)



