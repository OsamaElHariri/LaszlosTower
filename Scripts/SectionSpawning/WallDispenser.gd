extends Position2D

export(preload('res://Scripts/TOWER_TYPES.gd').types) var section_type
export var spawn_interval = 5.0

var section_to_spawn

func _ready():
	$IntervalSpawner.section_type = section_type
	$IntervalSpawner.spawn_interval = spawn_interval
	$IntervalSpawner.start()
	
	var symbol = TOWER_TYPES.get_information(section_type)['symbol']
	$PowerUpSymbol.texture = symbol
	$PowerUpSymbol.rotation -= rotation

func spawn(section):
	section_to_spawn = section
	$AnimationPlayer.play('Spawn')

func instantiate_section():
	get_parent().add_child(section_to_spawn)
	section_to_spawn.position = position
	