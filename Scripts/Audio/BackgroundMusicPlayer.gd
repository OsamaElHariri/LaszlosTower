extends AudioStreamPlayer

var initial_volume = 0
var step = 0.8
var non_audable_sound_volume = -80


func _ready():
	initial_volume = volume_db
	volume_db = non_audable_sound_volume
	EMITTER.connect('start_spawning', self, 'play_music')

func play_music():
	if !playing:
		play()

func _process(delta):
	if VARIABLES.play_background_loop && playing:
		volume_db = min(volume_db + step, initial_volume)
	else:
		volume_db = non_audable_sound_volume
