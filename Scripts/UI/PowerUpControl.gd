extends Position2D

var lever_scale_increase_limit = 1.2
var lever_scale_speed = 0.03

var mouse_inside_activation_area
var mouse_inside_discard_area

var initial_lever_y

var tracking_power_up_index = INF

var shortcut_display = ['Q/A', 'W/Z', 'E', 'R']

func _ready():
	if get_parent() && get_parent().get_parent():
		get_parent().get_parent().connect('discard_hover', self, 'display_warning')
		get_parent().get_parent().connect('discard_un_hover', self, 'clear_warning')
		
	initial_lever_y = $PowerUpPanelControl/BlueLever.position.y
	
	$ActivationControl.connect('gui_input', self, 'activation_clicked')
	$ActivationControl.connect('mouse_entered', self, 'enable_activation_emphasis')
	$ActivationControl.connect('mouse_exited', self, 'disable_activation_emphasis')
	
	$DiscardControl.connect('gui_input', self, 'discard_clicked')
	$DiscardControl.connect('mouse_entered', self, 'enable_discard_emphasis')
	$DiscardControl.connect('mouse_exited', self, 'disable_discard_emphasis')
	
	$PowerUpPanelControl/ActivateShortcutInfo/Label.text = '{0}'.format([tracking_power_up_index + 1])
	$PowerUpPanelControl/DiscardShortcutInfo/Label.text = '{0}'.format([shortcut_display[tracking_power_up_index]])

func display_warning(index):
	if tracking_power_up_index >= index && POWER_UPS.is_power_up(tracking_power_up_index):
		$PowerUpPanelControl/DiscardWarning.visible = true
	

func clear_warning():
	$PowerUpPanelControl/DiscardWarning.visible = false

func activation_clicked(event):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT and event.is_pressed():
		if POWER_UPS.can_select_index(tracking_power_up_index):
			POWER_UPS.selected_power_up_index = tracking_power_up_index

func enable_activation_emphasis():
	mouse_inside_activation_area = true
	show_shortcuts()

func disable_activation_emphasis():
	mouse_inside_activation_area = false
	hide_shortcuts()

func discard_clicked(event):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT and event.is_pressed():
		POWER_UPS.pop_index(tracking_power_up_index)

func enable_discard_emphasis():
	get_parent().get_parent().emit_signal('discard_hover', tracking_power_up_index)
	mouse_inside_discard_area = true
	show_shortcuts()

func disable_discard_emphasis():
	get_parent().get_parent().emit_signal('discard_un_hover')
	mouse_inside_discard_area = false
	hide_shortcuts()

func show_shortcuts():
	$PowerUpPanelControl/DiscardShortcutInfo.visible = true
	$PowerUpPanelControl/ActivateShortcutInfo.visible = true
	
func hide_shortcuts():
	$PowerUpPanelControl/DiscardShortcutInfo.visible = false
	$PowerUpPanelControl/ActivateShortcutInfo.visible = false

func _process(delta):
	update_blue_lever_scale()
	update_red_lever_scale()
	
	pull_blue_lever()
	pull_red_lever()
	
	set_symbol_texture()
	show_hide_out_of_order()
	show_hide_black_screen()

func update_blue_lever_scale():
	if mouse_inside_activation_area && $PowerUpPanelControl/BlueLever.scale.x < lever_scale_increase_limit:
		$PowerUpPanelControl/BlueLever.scale += Vector2(lever_scale_speed, lever_scale_speed)
	else:
		if $PowerUpPanelControl/BlueLever.scale.x > 1:
			$PowerUpPanelControl/BlueLever.scale -= Vector2(lever_scale_speed, lever_scale_speed)

func update_red_lever_scale():
	if mouse_inside_discard_area && $PowerUpPanelControl/RedLever.scale.x < lever_scale_increase_limit:
		$PowerUpPanelControl/RedLever.scale += Vector2(lever_scale_speed, lever_scale_speed)
	else:
		if $PowerUpPanelControl/RedLever.scale.x > 1:
			$PowerUpPanelControl/RedLever.scale -= Vector2(lever_scale_speed, lever_scale_speed)

func pull_blue_lever():
	if is_selected() && $PowerUpPanelControl/BlueLever.position.y < initial_lever_y + 15:
		$PowerUpPanelControl/BlueLever.position.y += 1
		$PowerUpPanelControl/BlueLever/BlueLeverBulb.position.y += 1.5
	elif !is_selected() && $PowerUpPanelControl/BlueLever.position.y > initial_lever_y:
		$PowerUpPanelControl/BlueLever.position.y -= 1
		$PowerUpPanelControl/BlueLever/BlueLeverBulb.position.y -= 1.5

func pull_red_lever():
	if no_power_up() && $PowerUpPanelControl/RedLever.position.y < initial_lever_y + 15:
		$PowerUpPanelControl/RedLever.position.y += 1
		$PowerUpPanelControl/RedLever/RedLeverBulb.position.y += 1.5
	elif !no_power_up() && $PowerUpPanelControl/RedLever.position.y > initial_lever_y:
		$PowerUpPanelControl/RedLever.position.y -= 1
		$PowerUpPanelControl/RedLever/RedLeverBulb.position.y -= 1.5

func set_symbol_texture():
	if !no_power_up():
		$PowerUpPanelControl/PowerUpSymbol.texture = POWER_UPS._collected_power_ups[tracking_power_up_index].type_symbol
	else:
		$PowerUpPanelControl/PowerUpSymbol.texture = null

func show_hide_out_of_order():
	$PowerUpPanelControl/OutOfOrderSymbol.visible = POWER_UPS.is_depleted(tracking_power_up_index)

func show_hide_black_screen():
	$PowerUpPanelControl/BlackScreen.visible = !POWER_UPS.is_power_up(tracking_power_up_index)

func is_selected():
	return tracking_power_up_index == POWER_UPS.selected_power_up_index && POWER_UPS.can_select_index(tracking_power_up_index)

func no_power_up():
	return !POWER_UPS.is_power_up(tracking_power_up_index)