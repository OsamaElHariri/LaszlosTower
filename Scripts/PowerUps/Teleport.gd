extends Position2D

var type = TOWER_TYPES.types.TELEPORT
var type_name = 'Teleport'
var type_description = 'Swap places with a tower part'
var type_symbol = load('res://Art/PowerUps/Teleport/TeleportSymbol.png')
var depleted = false
var active = false

var show_feedback = false

func _ready():
	$RayCast2D.add_exception(get_parent())
	
	$TriggerTimer.connect('timeout', self, 'swap_positions')
	$CleanUpTimer.connect('timeout', self, 'deactivate')

func swap_positions():
	depleted = true
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		var collider_position = collider.position
		collider.position = get_parent().position
		get_parent().position = collider_position
	$Particles2D.restart()
	$CleanUpTimer.start()


func _process(delta):
	if !show_feedback || active || depleted:
		$TeleportImpact.visible = false
		$Line2D.points[1] = Vector2(0, 0)
		return
		
	if $RayCast2D.is_colliding() && $RayCast2D.get_collider() != null && $RayCast2D.get_collider().is_in_group('has_engine'):
		var collision_point = to_local($RayCast2D.get_collision_point())
		$Line2D.points[1] = collision_point
		$TeleportImpact.visible = true
		$TeleportImpact.position = collision_point
	else:
		$TeleportImpact.visible = false
		$Line2D.points[1] = Vector2(0, 0)
		


func activate(direction):
	if depleted:
		return
	
	active = true
	
	$RayCast2D.rotation = Vector2(-1, 0).angle_to(direction)
	get_parent().get_node('CollisionShape2D').set_disabled(true)
	$SfxPlayer.play()
	$TriggerTimer.start()
	

func deactivate():
	get_parent().get_node('CollisionShape2D').set_disabled(false)
	depleted = true
	active = false
	hide_visual_feedback()
	destroy_after_interval()

func show_visual_feedback(updated_rotation):
	show_feedback = true
	$Line2D.visible = !depleted
	if !active:
		$RayCast2D.rotation = updated_rotation

func hide_visual_feedback():
	$Line2D.visible = false
	$TeleportImpact.visible = false
	show_feedback = false


func destroy_after_interval():
	if 'is_tower_section' in get_parent():
		var timer = Timer.new()
		timer.connect('timeout', get_parent(), 'discard')
		add_child(timer)
		timer.start()
