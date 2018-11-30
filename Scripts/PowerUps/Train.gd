extends Position2D

var type = TOWER_TYPES.types.TRAIN
var type_name = 'Train'
var type_description = 'Propel the tower in a direction'
var type_symbol = load('res://Art/PowerUps/Train/TrainSymbol.png')
var depleted = false
var active = false

var parent
var engine

var train_speed_multiplier = .7
var train_boost_direction

var old_parent_pos

func _ready():
	parent = get_parent()
	$VisualFeedback.scale *= VARIABLES.initial_scale_multiplier
	$PowerUpDuration.connect('timeout', self, 'deactivate')

func _process(delta):
	if active:
		var dist = get_parent().position.distance_to(old_parent_pos)
		$Tracks.region_rect.position.x += dist
		old_parent_pos = get_parent().position
		if $Tracks.region_rect.size.x < 1600:
			$Tracks.region_rect.size.x += 100
		parent.move_and_collide(train_boost_direction * delta * train_speed_multiplier * VARIABLES.default_tower_section_speed)
	else:
		if $Tracks.region_rect.size.x > 0:
			$Tracks.region_rect.size.x -= 200

func activate(direction):
	if !parent.is_in_group('has_engine') || depleted:
		return
	direction = direction.normalized()
	
	engine = parent.get_node('Engine')
	engine.power_off()
	train_boost_direction = direction
	engine.move_direction = train_boost_direction
	$Tracks.rotation = Vector2(1, 0).angle_to(direction)
	old_parent_pos = get_parent().position
	active = true
	depleted = true
	$SfxPlayer.play()
	$PowerUpDuration.start()

func deactivate():
	$SfxPlayer.stop()
	depleted = true
	$PowerUpDuration.stop()
	if train_boost_direction:
		engine.move_direction = train_boost_direction
	active = false
	if engine:
		engine.power_on()
	hide_visual_feedback()
	destroy_after_interval()

func show_visual_feedback(updated_rotation):
	$VisualFeedback.visible = !depleted && !active
	$VisualFeedback.rotation = updated_rotation

func hide_visual_feedback():
	$VisualFeedback.visible = false

func destroy_after_interval():
	if 'is_tower_section' in get_parent():
		var timer = Timer.new()
		timer.connect('timeout', get_parent(), 'discard')
		add_child(timer)
		timer.start()
