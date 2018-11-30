extends Position2D

enum AnimationStep {Trashcan, Morning, Wakeup}

var current_animation = AnimationStep.Trashcan

func _ready():
	$TrashcanPaperThrow.play('Throw')
	$LaszloBreathe.play('Breathe')
	
	$TrashcanPaperThrow.connect('animation_finished', self, 'onAnimationEnd')
	$NighToMorning.connect('animation_finished', self, 'onAnimationEnd')
	$WakeUp.connect('animation_finished', self, 'onAnimationEnd')
	$Timer.connect('timeout', self, 'afterDelay')

func onAnimationEnd(animation_string):
	if current_animation == AnimationStep.Trashcan:
		$Timer.wait_time = 3
		$Timer.start()
	elif current_animation == AnimationStep.Morning:
		$Timer.wait_time = 2
		$Timer.start()
	elif current_animation == AnimationStep.Wakeup:
		$Timer.wait_time = 1.5
		$Timer.start()

func afterDelay():
	if current_animation == AnimationStep.Trashcan:
		$NighToMorning.play('Morning')
		current_animation = AnimationStep.Morning
	elif current_animation == AnimationStep.Morning:
		$LaszloBreathe.stop()
		$WakeUp.play('WakeUp')
		current_animation = AnimationStep.Wakeup
	elif current_animation == AnimationStep.Wakeup:
		if get_parent().has_method('animation_finished'):
			get_parent().animation_finished()