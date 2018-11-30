extends Position2D

var effect = load('res://Scenes/TowerSection/SectionDiscardEffect.tscn')


func _ready():
	FACTORIES.clear()
	FACTORIES.add(TOWER_TYPES.types.TRAIN, 4)
	FACTORIES.add(TOWER_TYPES.types.TELEPORT, 4)
	FACTORIES.add(TOWER_TYPES.types.PULSE, 4)
	FACTORIES.add(TOWER_TYPES.types.LASER, 4)
	EMITTER.emit('start_spawning')
	EMITTER.connect('power_up_destroyed', self, 'on_section_destroyed')


func on_section_destroyed(destruction_info):
	var effect_instance = effect.instance()
	effect_instance.play(destruction_info.pos)
	add_child(effect_instance)