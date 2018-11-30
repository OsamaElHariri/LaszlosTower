extends Position2D

var can_remove = false

func _ready():
	$DiscardTimer.connect('timeout', self, 'set_can_remove_true')
	POWER_UPS.connect('selected_index_changed', self, 'index_changed')

func set_can_remove_true():
	can_remove = true

func index_changed():
	var i = 0
	while i < POWER_UPS._collected_power_ups.size():
		if POWER_UPS.is_depleted(i):
			show_discard_hint()
		i += 1

func show_discard_hint():
	visible = true
	$DiscardTimer.start()

func _input(event):
	if can_remove && event is InputEventMouseButton && event.is_pressed():
		queue_free()