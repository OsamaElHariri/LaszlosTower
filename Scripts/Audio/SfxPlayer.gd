extends AudioStreamPlayer2D

export var volume = 0

func _process(delta):
	volume_db = volume if VARIABLES.play_sfx else -80
