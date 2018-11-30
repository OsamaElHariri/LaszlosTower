extends Position2D

var type = TOWER_TYPES.types.PULSE
var type_name = 'Pulse'
var type_description = 'Repel adjacent tower parts'
var type_symbol = load('res://Art/PowerUps/Pulse/PulseSymbol.png')
var depleted = false
var active = false

var pulse_range = 15

func _ready():
	$VisualFeedback.scale *= VARIABLES.initial_scale_multiplier
	$PulseWave.scale *= VARIABLES.initial_scale_multiplier
	$TriggerTimer.connect('timeout', self, 'push_objects')

func push_objects():
	depleted = true
	if !has_node('Area2D'):
		return
		
	for body in $Area2D.get_overlapping_bodies():
		if body.is_in_group('has_engine') && body != get_parent():
			var engine = body.get_node('Engine')
			var new_direction = body.position - get_parent().position
			engine.move_direction = new_direction.normalized()
			
	deactivate()

func activate(dir):
	if depleted:
		return
	active = true
	
	if 'is_tower_section' in get_parent():
		$Area2D/CollisionShape2D.get_shape().radius = tower_section_radius()
	else:
		$Area2D/CollisionShape2D.get_shape().radius = tower_radius()
	
	$SfxPlayer.play()
	$TriggerTimer.start()
	pulse_visual()
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
	$VisualFeedback.scale = Vector2(1, 1) * get_tower_scale_addition()

func tower_radius():
	var initial_radius = $VisualFeedback.texture.get_width() / 2
	var scale_multiplier = get_tower_scale_addition()
	return initial_radius * scale_multiplier

func tower_section_radius():
	var initial_radius = $VisualFeedback.texture.get_width() / 2
	var scale_multiplier = get_section_scale_addition()
	return initial_radius * scale_multiplier

func get_tower_scale_addition():
	return VARIABLES.initial_scale_multiplier + (VARIABLES.tower_section_scale_multiplier * (POWER_UPS._collected_power_ups.size() + pulse_range))

func get_section_scale_addition():
	return VARIABLES.initial_scale_multiplier + (VARIABLES.tower_section_scale_multiplier *  pulse_range)

func pulse_visual():
	var tween_duration = 0.2
	$PulseWave.modulate.a = 1
	$PulseModulate.interpolate_property($PulseWave,'modulate',Color(1,1,1,1), Color(1,1,1,0),tween_duration * 0.1,Tween.TRANS_LINEAR,Tween.EASE_OUT,tween_duration * .9)
	$PulseModulate.start()
	
	$PulseScale.interpolate_property($PulseWave,'scale',Vector2(0, 0), Vector2(1, 1) * get_tower_scale_addition() ,tween_duration,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$PulseScale.start()

func hide_visual_feedback():
	$VisualFeedback.visible = false

func destroy_after_interval():
	if 'is_tower_section' in get_parent():
		var timer = Timer.new()
		timer.connect('timeout', get_parent(), 'discard')
		add_child(timer)
		timer.start()