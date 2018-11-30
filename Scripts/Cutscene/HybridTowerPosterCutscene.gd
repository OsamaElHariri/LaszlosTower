extends Position2D

func _ready():
	$Unroll.play('Unroll')
	$Unroll.connect('animation_finished', self, 'onAnimationEnd')

func onAnimationEnd(animation_string):
	if get_parent().has_method('animation_finished'):
		get_parent().animation_finished()
