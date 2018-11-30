extends Sprite


var rotation_multiplier = 1

func _ready():
	rotation = randf()
	if get_parent().is_in_group('has_collided_signal'):
		get_parent().connect('has_collided', self, 'on_collision')

func _process(delta):
	rotation += VARIABLES.tower_section_rotation_speed * rotation_multiplier * delta
	
	$TowerSectionLight.rotation = get_global_transform().get_origin().angle_to_point(VARIABLES.light_point) - rotation

func on_collision(collider):
	toggle_rotation_direction()

func toggle_rotation_direction():
	rotation_multiplier *= -1
	
func discard():
	queue_free()