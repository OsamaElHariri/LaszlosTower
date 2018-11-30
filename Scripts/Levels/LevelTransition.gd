extends Position2D

export var end_of_level = false

var closed_gate = false

var tower

func _ready():
	position.y = -60
	$TransitionTimer.connect('timeout', self, 'go_to_next_level')
	$SafetyNetTimer.connect('timeout', self, 'go_to_next_level')
	$Center/Area2D.connect('body_entered', self, 'tower_entered')
	$Center/Area2D.connect('body_exited', self, 'tower_exit')
	
	var collider_to_detect_player
	
	if !end_of_level:
		collider_to_detect_player = $LeftWall
		if get_parent().has_node('Tower'):
			var sibling_tower = get_parent().get_node('Tower')
			sibling_tower.position = position + $Target.position
			sibling_tower.get_node('Engine').move_direction = Vector2(1, 0)
	else:
		collider_to_detect_player = $RightWall
	
	collider_to_detect_player.set_collision_layer_bit(0, 1)

func tower_entered(player_tower):
	$AnimationPlayer.play('OpenLeft')
	var engine = player_tower.get_node('Engine')
	if end_of_level:
		engine.power_off()
		tower = player_tower
		POWER_UPS.pop_index(0)
		$SafetyNetTimer.start()
	else:
		engine.move_direction = Vector2(1, 0)

func tower_exit(tower):
	if !closed_gate:
		$AnimationPlayer.play('CloseRight')
	closed_gate = true
	if !end_of_level:
		$RightWall.set_collision_layer_bit(0, 1)


func _process(delta):
	$Center/Escalator.region_rect.position.x -= 3
	
	if tower:
		var target = position + $Target.position
		if target.distance_to(tower.position) < 5:
			$TransitionTimer.start()
			tower = null
			return
		var angle_offset = target.angle_to_point(tower.position)
		tower.move_and_collide(Vector2(1, 0).rotated(angle_offset) * delta * VARIABLES.default_tower_section_speed)
	
func go_to_next_level():
	EMITTER.emit('level_complete')
