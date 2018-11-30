extends Sprite

func _ready():
	$LaszloAnimation.play('Drive')

func _process(delta):
	$CockPitLight.rotation = (get_global_transform().get_origin().angle_to_point(VARIABLES.light_point)) - rotation
