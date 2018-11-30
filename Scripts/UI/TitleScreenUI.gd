extends Position2D

var already_started = false

func _ready():
	$FadeAway.connect('tween_completed', self, 'on_tween_complete')
	$StartGameTimer.connect('timeout', self, 'start_game')

func _input(event):
	if already_started:
		return
	
	if (event is InputEventMouseButton && event.is_pressed()) \
	|| event.is_action_pressed('ui_accept'):
		fade_to_black()
		already_started = true

func fade_to_black():
	$FadeAway.interpolate_property($Title,'modulate',Color(1,1,1,1), Color(1,1,1,0),1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$FadeAway.start()
	
func on_tween_complete(prop, obj):
	$StartGameTimer.start()

func start_game():
	EMITTER.emit('game_start')
