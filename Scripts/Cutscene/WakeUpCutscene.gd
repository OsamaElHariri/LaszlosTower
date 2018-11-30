extends Position2D

enum AnimationStep {InitialDelay, PaperFall, Happy}

var current_animation = AnimationStep.InitialDelay

func _ready():
	$Eureka.connect('animation_finished', self, 'onAnimationEnd')
	
	$Timer.connect('timeout', self, 'afterDelay')
	$Timer.start()
	

func onAnimationEnd(animation_string):
	if current_animation == AnimationStep.PaperFall:
		$Timer.wait_time = 1.4
		$Timer.start()
	if current_animation == AnimationStep.Happy:
		$Timer.wait_time = 1.6
		$Timer.start()

func afterDelay():
	if current_animation == AnimationStep.InitialDelay:
		$Eureka.play('PaperFalling')
		current_animation = AnimationStep.PaperFall
	elif current_animation == AnimationStep.PaperFall:
		$Eureka.play('BecomeHappy')
		current_animation = AnimationStep.Happy
	elif current_animation == AnimationStep.Happy:
		if get_parent().has_method('animation_finished'):
			get_parent().animation_finished()