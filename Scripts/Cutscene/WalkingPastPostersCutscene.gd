extends Position2D

func _ready():
	$Posters/LabLight/LightSwing.play('Swing')
	$Timer2.connect('timeout', self, 'startWalking')
	$Timer2.start()
	
	$Timer.connect('timeout', self, 'afterDelay')
	$Timer.start()
	
	$MoveShadowAndPosters.connect('animation_finished', self, 'onAnimationEnd')

func startWalking():
	return
	$WalkCycle.play('Walk')

func afterDelay():
	$WalkCycle.play('Walk')
	$MoveShadowAndPosters.play('PanCamera')

func onAnimationEnd(animation_string):
	if animation_string == 'PanCamera':
		$MoveShadowAndPosters.play('Move')
	elif animation_string == 'Move':
		if get_parent().has_method('animation_finished'):
			get_parent().animation_finished()

