extends Position2D

var particle_position

var has_started = false

func _ready():
	$Timer.connect('timeout', self, 'queue_free')
	if position.distance_to(VARIABLES.current_tower_position) < 5:
		$SfxPlayer.volume -= 12
	$SfxPlayer.play()


func play(pos=Vector2(0, 0)):
	position = pos
	rotation = 2 * PI * randf()
	$Section.restart()
	$Debris.restart()
	$SmokeCloud.restart()
	$Timer.start()
