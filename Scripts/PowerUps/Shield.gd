extends Position2D

var type = TOWER_TYPES.types.SHIELD
var type_name = 'Shield'
var type_description = 'Protects against damage'
var type_symbol = load('res://Art/PowerUps/Shield/Symbol.png')
var depleted = false
var active = false


func _ready():
	scale *= VARIABLES.initial_scale_multiplier

func _process(delta):
	$ActiveVisuals.visible = get_parent().invincible


func activate(dir):
	if depleted:
		return
	depleted = true
	
	if 'is_tower_section' in get_parent():
		$ActiveVisuals.scale = Vector2(1, 1)
	else:
		var new_scale = 1 + VARIABLES.tower_section_scale_multiplier * POWER_UPS._collected_power_ups.size()
		$ActiveVisuals.scale = Vector2(new_scale, new_scale)
	get_parent().invincible = true
	
#	$SfxPlayer.play()
	$ActiveVisuals/Particles2D.restart()
	destroy_after_interval()

func deactivate():
	active = false
	depleted = true
	get_parent().invincible = false
	$ActiveVisuals/Particles2D.emitting = false
	$ActiveVisuals.visible = false
	hide_visual_feedback()

func show_visual_feedback(updated_rotation):
	$VisualFeedback.visible = !depleted
	var new_scale = 1 + VARIABLES.tower_section_scale_multiplier * POWER_UPS._collected_power_ups.size()
	$VisualFeedback.scale = Vector2(new_scale, new_scale)

func hide_visual_feedback():
	$VisualFeedback.visible = false

func destroy_after_interval():
	if 'is_tower_section' in get_parent():
		get_parent().invincible = true
		var timer = Timer.new()
		timer.wait_time = 2
		timer.connect('timeout', self, 'after_interval')
		add_child(timer)
		timer.start()

func after_interval():
	get_parent().invincible = false
	get_parent().discard()
