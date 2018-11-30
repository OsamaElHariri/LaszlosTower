extends CanvasLayer

signal discard_hover
signal discard_un_hover

var power_up_control_scene = load('res://Scenes/UI/PowerUpControl.tscn')

var level_select_closed = true

func _ready():
	$LevelSelectButton.connect('button_up', self, 'toggle_level_select_menu')
	$RestartButton.connect('button_up', self, 'restart_level')
	$QuitButton.connect('button_up', self, 'quit_game')
	$MuteMusic.connect('button_up', self, 'toggle_music')
	$MuteSFX.connect('button_up', self, 'toggle_sfx')
	
	var control_width = 250
	
	var i = 0
	while i < VARIABLES.max_sections:
		var power_up_control = power_up_control_scene.instance()
		power_up_control.position.x += i * control_width
		power_up_control.tracking_power_up_index = i
		$PowerUpControls.add_child(power_up_control)
		
		i += 1

func toggle_level_select_menu():
	level_select_closed = !level_select_closed

func _process(delta):
	if level_select_closed:
		$LevelSelectMenu.position.y = min(1100, $LevelSelectMenu.position.y + 50)
	else:
		$LevelSelectMenu.position.y = max(450, $LevelSelectMenu.position.y - 50)

func restart_level():
	LEVEL_TRANSITION.load_current_level()

func quit_game():
	EMITTER.emit('quit_game')

func toggle_music():
	var music_state = !VARIABLES.play_background_loop
	VARIABLES.play_background_loop = music_state
	$MuteMusic/RedBar.visible = !music_state

func toggle_sfx():
	var sfx_state = !VARIABLES.play_sfx
	VARIABLES.play_sfx = sfx_state
	$MuteSFX/RedBar.visible = !sfx_state

