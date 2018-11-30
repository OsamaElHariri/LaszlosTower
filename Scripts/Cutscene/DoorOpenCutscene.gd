extends Position2D

func _ready():
	$LabLight/LightSwing.play('Swing')
	$Door.connect('animation_finished', self, 'onAnimationEnd')
	$Timer.connect('timeout', self, 'afterDelay')
	EMITTER.connect('game_start', self, 'start_animation')

func start_animation():
	$Door.play('OpenCloseDoor')

func onAnimationEnd(animation_string):
	$Timer.start()

func afterDelay():
	if get_parent().has_method('animation_finished'):
		get_parent().animation_finished()
