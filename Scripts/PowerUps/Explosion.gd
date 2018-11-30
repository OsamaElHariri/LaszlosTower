extends Position2D

var type = TOWER_TYPES.types.EXPLOSION
var type_name = 'Explosion'
var type_description = 'Wreak havoc'
var type_symbol = load('res://Art/PowerUps/Explosion/Symbol.png')
var depleted = false
var active = false

var pulse_range = 15

func _ready():
	$TriggerTimer.connect('timeout', self, 'destroy_objects')

func destroy_objects():
	depleted = true
	if !has_node('Area2D'):
		return
		
	for body in $Area2D.get_overlapping_bodies():
		if body.is_in_group('has_engine') && body != get_parent():
			body.discard()
			
	deactivate()

func activate(dir):
	if depleted:
		return
	active = true
	
	$SfxPlayer.play()
	$TriggerTimer.start()
	$AnimationPlayer.play('Explosion')
	if not 'is_tower_section' in get_parent():
		EMITTER.emit('camera_shake')

func deactivate():
	active = false
	depleted = true
	if has_node('Area2D'):
		$Area2D.queue_free()
	hide_visual_feedback()
	destroy_after_interval()

func show_visual_feedback(updated_rotation):
	$VisualFeedback.visible = !depleted

func hide_visual_feedback():
	$VisualFeedback.visible = false

func destroy_after_interval():
	if 'is_tower_section' in get_parent():
		var timer = Timer.new()
		timer.connect('timeout', get_parent(), 'discard')
		add_child(timer)
		timer.start()