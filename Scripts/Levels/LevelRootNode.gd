extends Position2D

export var description = ''

export var explosion = 0
export var laser = 0
export var pulse = 0
export var shield = 0
export var teleport = 0
export var train = 0


var effect = load('res://Scenes/TowerSection/SectionDiscardEffect.tscn')

func _ready():
	FACTORIES.clear()
	FACTORIES.add(TOWER_TYPES.types.EXPLOSION, explosion)
	FACTORIES.add(TOWER_TYPES.types.LASER, laser)
	FACTORIES.add(TOWER_TYPES.types.PULSE, pulse)
	FACTORIES.add(TOWER_TYPES.types.SHIELD, train)
	FACTORIES.add(TOWER_TYPES.types.TELEPORT, teleport)
	FACTORIES.add(TOWER_TYPES.types.TRAIN, train)
	
	EMITTER.emit('start_spawning')
	EMITTER.connect('power_up_destroyed', self, 'on_section_destroyed')

func on_section_destroyed(destruction_info):
	var effect_instance = effect.instance()
	effect_instance.play(destruction_info.pos)
	add_child(effect_instance)
