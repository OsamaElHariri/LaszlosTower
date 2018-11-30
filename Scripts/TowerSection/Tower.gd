extends KinematicBody2D

signal has_collided

var tower_section_sprite_scene = load('res://Scenes/TowerSection/TowerSectionSprite.tscn')

var collected_tower_sections = []

var generic_tower_section

var current_power_up

var invincible = false

var current_sound_player_index = 0
var sound_players = []

func _ready():
	$Visuals/CockPit.scale *= VARIABLES.initial_scale_multiplier
	
	sound_players = [$CollisionSound1, $CollisionSound2, $CollisionSound3]
	
	EMITTER.connect('request_add_section', self, 'request_section_addition')
	POWER_UPS.connect('power_ups_changed', self, 'sync_tower_and_power_ups')
	POWER_UPS.connect('selected_index_changed', self, 'update_current_power_up')
	$GrabRange.connect('body_entered', self, 'can_grab_body')
	$GrabRange.connect('body_exited', self, 'cannot_grab_body')
	
	current_power_up = load('res://Scenes/PowerUps/EmptyPowerUp.tscn').instance()
	add_child(current_power_up)
	
	generic_tower_section = tower_section_sprite_scene.instance()
	
	fix_tower()


func update_current_power_up():
	remove_child(current_power_up)
	current_power_up = POWER_UPS.get_selected_power_up()
	add_child(current_power_up)


func sync_tower_and_power_ups():
	update_tower_section_count(POWER_UPS._collected_power_ups.size())
	fix_tower()


# update the number of sections the tower has,
# this is done by adding or removing sections from the collected sections
# until the number of collected sections is equal to the count
func update_tower_section_count(count):
	if count < collected_tower_sections.size():
		var i = collected_tower_sections.size() - 1
		while i >= count:
			collected_tower_sections[i].discard()
			collected_tower_sections.remove(i)
			i -= 1
	else:
		var i = collected_tower_sections.size()
		while i < count:
			add_section_to_tower()
			i += 1


func fix_tower():
	update_collision_size()
	update_grab_range_size()
	update_grabbing_clamp()
	
	var count = collected_tower_sections.size()
	
	var i = 0
	while i < count:
		# top section rotation multiplier is 2,
		# lowest section multiplier is 1
		collected_tower_sections[i].rotation_multiplier = 1 + (count - i + 1) / count
		
		i += 1


# update the size of the tower's collider
func update_collision_size():
	$CollisionShape2D.get_shape().radius = get_tower_radius()
	
	# subtract arbitrary number so the collision looks more pleasing
	$CollisionShape2D.get_shape().radius -= 5


# update the range where a section can be grabbed and added to the tower
func update_grab_range_size():
	$GrabRange/CollisionShape2D.get_shape().radius = get_tower_radius(2)

func update_grabbing_clamp():
	var new_clamp_scale = 1 + (VARIABLES.tower_section_scale_multiplier * (collected_tower_sections.size() - 4))
	$Visuals/CockPit/GrabbingPole.scale = Vector2(new_clamp_scale, new_clamp_scale)
	$Visuals/CockPit/GrabbingPole2.scale = Vector2(new_clamp_scale, new_clamp_scale)
	
	$Visuals/CockPit/GrabbingPole.z_index = -collected_tower_sections.size() - 1
	$Visuals/CockPit/GrabbingPole2.z_index = -collected_tower_sections.size() - 1


# get the radius of the tower as it is now, plus an offset amount of sections.
# so if the tower now has one section and the offset is 1, the radius
# of the tower with two sections is returned
func get_tower_radius(offset=0):
	var requested_tower_length = collected_tower_sections.size() + offset
	if requested_tower_length <= 0:
		return $Visuals/CockPit.texture.get_width() * $Visuals/CockPit.scale.x / 2
	else:
		var scale_addition = VARIABLES.tower_section_scale_multiplier * (requested_tower_length - 1)
		return generic_tower_section.texture.get_width() * (generic_tower_section.scale.x + scale_addition) / 2


func _process(delta):
	VARIABLES.current_tower_position = position
	
	var mouse_pos = get_global_mouse_position()
	var look_at_angle = position.angle_to_point(mouse_pos)
	if !$GrabAnimation.is_playing():
		$Visuals/CockPit.rotation = look_at_angle
	
	current_power_up.show_visual_feedback(look_at_angle)


func can_grab_body(body):
	if can_add_section_to_tower(body) && body.has_method('combine_tower_on'):
		body.combine_tower_on()


func cannot_grab_body(body):
	if body.has_method('combine_tower_off'):
		body.combine_tower_off()


# perform checks and prepare to add section
func request_section_addition(requesting_section):
	if can_add_section_to_tower(requesting_section):
		add_section(requesting_section)
		$GrabAnimation.play('Grab')
		$GrabSFX.play()


func can_add_section_to_tower(section):
	return collected_tower_sections.size() < VARIABLES.max_sections \
	&& section.is_in_group('has_collided_signal') \
	&& not section in collected_tower_sections \
	&& section.has_method('get_power_up') \
	&& POWER_UPS.get_selected_power_up().depleted


func add_section(tower_section):
	var section_rotation = null
	if tower_section.has_method('get_tower_section_rotation'):
		section_rotation = tower_section.get_tower_section_rotation()
	
	add_section_to_tower(to_local(tower_section.position), section_rotation)
	POWER_UPS.add_power_up(tower_section.get_power_up())
	tower_section.queue_free()

func add_section_to_tower(starting_pos=Vector2(0, 0), initial_rotation=null):
	var new_section_index = collected_tower_sections.size()
	
	var new_section = tower_section_sprite_scene.instance()
	collected_tower_sections.append(new_section)
	
	# the new_section is not added to $Visuals because it is being animated.
	# the new_section will be added when the animations are done
	add_child(new_section)
	
	new_section.position = starting_pos
	
	# lower levels have a lower z-index
	new_section.z_index = $Visuals/CockPit.z_index - collected_tower_sections.size()
	
	if initial_rotation:
		new_section.rotation = initial_rotation
	
	tween_section(new_section, new_section_index, starting_pos)
	
	$JumpAnimation.play('Jump')
	
	fix_tower()


# animate the new section
func tween_section(new_section, section_index, starting_pos):
	var tween_speed = 0.35
	
	# tween the scale from original scale to the size it should be at the given index
	var scale_tween = Tween.new()
	add_child(scale_tween)
	var new_scale = new_section.scale.x + VARIABLES.tower_section_scale_multiplier * section_index
	scale_tween.interpolate_property(new_section, 'scale', new_section.scale, Vector2(new_scale, new_scale), tween_speed, Tween.TRANS_LINEAR,Tween.EASE_IN)
	scale_tween.start()
	
	# darken the section based on the section index. Lower sections are darker
	var modulate_tween = Tween.new()
	add_child(modulate_tween)
	var darker_modulate_value = 1 - section_index * 0.04
	var new_modulate = Color(darker_modulate_value, darker_modulate_value, darker_modulate_value, 1.0)
	modulate_tween.interpolate_property(new_section, 'modulate', Color(1, 1, 1, 1), new_modulate, tween_speed, Tween.TRANS_LINEAR,Tween.EASE_IN)
	modulate_tween.start()
	
	# tween position from starting_pos to the center of the tower
	var pos_tween = Tween.new()
	add_child(pos_tween)
	pos_tween.interpolate_property(new_section, 'position', starting_pos, Vector2(0, 0), tween_speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	pos_tween.start()
	
	# use this tween to signal when all the tweens are done,
	# since all take the same amount of time
	pos_tween.connect('tween_completed', self, 'finish_adding_section', [[pos_tween, scale_tween, modulate_tween]])


# add the new section to $Visuals and clean up
func finish_adding_section(new_section, node_path, items_to_free):
	remove_child(new_section)
	$Visuals.add_child(new_section)
	for item in items_to_free:
		item.queue_free()


func collide_with(collider):
	emit_signal('has_collided', collider)
	$Visuals.collided_with(collider)
	play_collision_sound()

func play_collision_sound():
	if !sound_players[current_sound_player_index].playing:
		sound_players[current_sound_player_index].play()
		current_sound_player_index = (current_sound_player_index + 1) % sound_players.size()
	


func _unhandled_input(event):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.is_pressed():
		if current_power_up.active:
			return
			
		current_power_up.activate(get_global_mouse_position() - position)
	
	handle_selection_shortcuts(event)
	handle_discard_shortcuts(event)


func handle_selection_shortcuts(event):
	if event.is_action_pressed('select_power_up_1'):
		select_power_up_at(0)
	elif event.is_action_pressed('select_power_up_2'):
		select_power_up_at(1)
	elif event.is_action_pressed('select_power_up_3'):
		select_power_up_at(2)
	elif event.is_action_pressed('select_power_up_4'):
		select_power_up_at(3)


func select_power_up_at(index):
	if POWER_UPS.can_select_index(index):
			POWER_UPS.selected_power_up_index = index


func handle_discard_shortcuts(event):
	if event.is_action_pressed('discard_power_up_1'):
		remove_power_up_at(0)
	elif event.is_action_pressed('discard_power_up_2'):
		remove_power_up_at(1)
	elif event.is_action_pressed('discard_power_up_3'):
		remove_power_up_at(2)
	elif event.is_action_pressed('discard_power_up_4'):
		remove_power_up_at(3)


func remove_power_up_at(index):
	POWER_UPS.pop_index(index)


func discard():
	if !invincible:
		POWER_UPS.pop_tail(1)
	else:
		invincible = false
		
