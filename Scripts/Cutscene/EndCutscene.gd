extends Position2D

func _ready():
	$AnimationPlayer.play('EndScene')


func _input(event):
	if event is InputEventMouseButton && event.is_pressed():
		EMITTER.emit('restart_game')
