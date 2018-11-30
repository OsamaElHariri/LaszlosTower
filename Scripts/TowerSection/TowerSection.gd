extends KinematicBody2D

signal has_collided

var clickable = false
var can_combine_into_tower = false

var is_tower_section = true

var power_up_tscn
var power_up

var invincible = false


func _ready():
	connect('mouse_entered', self, 'can_click')
	connect('mouse_exited', self, 'cannot_click')
	$TowerSection/Symbol.rotation_degrees = randf() * 360


func collide_with(collider):
	emit_signal('has_collided', collider)
	if !$SfxPlayer.playing:
		$SfxPlayer.play()


func discard():
	if !invincible:
		EMITTER.emit('power_up_destroyed', {
			'pos': position,
			'type': power_up.type,
		})
		queue_free()
	else:
		invincible = false


func _input(event):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT and event.is_pressed():
		if clickable && can_combine_into_tower:
			EMITTER.emit('request_add_section', self)


func set_power_up_tscn_and_power_up(tscn):
	power_up_tscn = tscn
	set_power_up(tscn.instance())


func set_power_up(power_up_scene):
	$TowerSection/Symbol.texture = power_up_scene.type_symbol
	power_up = power_up_scene
	add_child(power_up)
	$AutoTrigger.start_auto_trigger()


func combine_tower_on():
	$TowerSectionGlow.visible = true
	can_combine_into_tower = true


func combine_tower_off():
	$TowerSectionGlow.visible = false
	can_combine_into_tower = false


func can_click():
	clickable = true


func cannot_click():
	clickable = false


func get_tower_section_rotation():
	return $TowerSection.rotation


func get_power_up():
	return power_up_tscn.instance()