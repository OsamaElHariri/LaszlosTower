extends Position2D

var current_level

func _ready():
	EMITTER.connect('load_level', self, 'load_level')


func load_level(lvl=null):
	if current_level:
		current_level.queue_free()
	if lvl == null:
		return
	current_level = LEVEL_TRANSITION.level_scenes[lvl].instance()
	add_child(current_level)
