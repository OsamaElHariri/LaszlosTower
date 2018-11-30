extends Label

func _ready():
	var current_level_index = LEVEL_TRANSITION.find_index_of(LEVEL_TRANSITION.current_level)
	text = 'Level {0}'.format([current_level_index + 1])
	$LevelDescription.text = get_parent().get_parent().description
	$AnimationPlayer.play('FadeInOut')
