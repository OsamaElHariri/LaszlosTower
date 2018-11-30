extends Position2D

export(preload('res://Scripts/TOWER_TYPES.gd').types) var section_type

export var dir = Vector2(0, 0)
export var auto_trigger = false

func _ready():
	EMITTER.connect('start_spawning', self, 'spawn_section')

func spawn_section():
	if FACTORIES.can_dispense(section_type):
		var new_section = FACTORIES.dispense(section_type)
		get_parent().add_child(new_section)
		new_section.position = position
		if dir.length() != 0:
			new_section.get_node('Engine').move_direction = dir.normalized()
		if !auto_trigger:
			new_section.get_node('AutoTrigger').disable()
	queue_free()