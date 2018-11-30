extends Position2D

var type = TOWER_TYPES.types.LASER
var type_name = 'Laser Beam'
var type_description = 'Destroy tower parts with a laser blast'
var type_symbol = load('res://Art/PowerUps/LaserBeam/LaserBeamSymbol.png')
var depleted = false
var active = false

func _ready():
	$LaserBeamShrink.interpolate_property($Beam/LaserBeam, 'scale', Vector2(3.11, 0.8), Vector2(0, 0), 0.12,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT, 0.13)
	$LaserBeamShrink.connect('tween_completed', self, 'deactivate_from_tween')
	
	$TriggerTimer.connect('timeout', self, 'destroy_objects')

func deactivate_from_tween(body, path_name):
	deactivate()

func destroy_objects():
	depleted = true
	if !has_node('Beam'):
		return
	for body in $Beam.get_overlapping_bodies():
		if body != get_parent() && body.has_method('discard'):
			body.discard()

func activate(direction):
	if depleted:
		return
	active = true
	
	$Beam.rotation_degrees = rad2deg(Vector2(-1, 0).angle_to(direction))
	$Beam/LaserBeam.visible = true
	$Beam/CollisionShape2D.disabled = false
	$SfxPlayer.play()
	$TriggerTimer.start()
	$LaserBeamShrink.start()
	if not 'is_tower_section' in get_parent():
		EMITTER.emit('camera_shake')

func deactivate():
	depleted = true
	active = false
	if has_node('Beam'):
		$Beam.queue_free()
	hide_visual_feedback()
	destroy_after_interval()
	

func show_visual_feedback(updated_rotation):
	$VisualFeedback.visible = !depleted
	$VisualFeedback.rotation = updated_rotation

func hide_visual_feedback():
	$VisualFeedback.visible = false

func destroy_after_interval():
	if 'is_tower_section' in get_parent():
		var timer = Timer.new()
		timer.connect('timeout', get_parent(), 'discard')
		add_child(timer)
		timer.start()
