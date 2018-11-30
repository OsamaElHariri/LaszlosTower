extends Position2D

export var duration = 10.0

var stopped = false

var trigger_direction

func _ready():
	trigger_direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()
	
	$AutoTrigger.interpolate_property($TextureProgress, 'value', 0, 100, duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$AutoTrigger.connect('tween_completed', self, 'trigger_power_up', [trigger_direction])
	
	get_parent().connect('mouse_entered', self, 'show_visual_feedback')
	get_parent().connect('mouse_exited', self, 'hide_visual_feedback')

func trigger_power_up(tween_str, tween_obj, dir):
	if 'is_tower_section' in get_parent():
		get_parent().power_up.activate(dir)
		
	$TextureProgress.value = 0


func start_auto_trigger():
	if !stopped:
		$AutoTrigger.start()


func show_visual_feedback():
	if !stopped:
		var look_at_angle = trigger_direction.angle_to(Vector2(-1, 0))
		get_parent().power_up.show_visual_feedback(-look_at_angle)

func hide_visual_feedback():
	get_parent().power_up.hide_visual_feedback()

func disable():
	stopped = true
	$AutoTrigger.stop_all()
	$TextureProgress.value = 0
