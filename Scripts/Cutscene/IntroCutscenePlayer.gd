extends Node2D

var open_door = load('res://Scenes/Cutscene/DoorOpenCutscene.tscn').instance()
var walk_past_posters = load('res://Scenes/Cutscene/WalkingPastPostersCutscene.tscn').instance()
var work_desk = load('res://Scenes/Cutscene/WorkDeskCutscene.tscn').instance()
var wake_up = load('res://Scenes/Cutscene/WakeUpCutscene.tscn').instance()
var put_up_poster = load('res://Scenes/Cutscene/HybridTowerPosterCutscene.tscn').instance()

var animation_index = 0
var animation_sequence = [open_door, \
						  walk_past_posters, \
						  work_desk, \
						  wake_up, \
						  put_up_poster]

var can_skip = false

func _ready():
	add_animation_at_index()
	EMITTER.connect('game_start', self, 'game_start')
	$CanvasLayer2/QuitButton.connect('button_up', self, 'quit_game')
	$RegisterStartTimer.connect('timeout', self, 'register_start')

func game_start():
	$RegisterStartTimer.start()

func register_start():
	$CanvasLayer/TextHolder.visible = true
	can_skip = true

func _input(event):
	if can_skip && event.is_action_pressed('ui_accept'):
		remove_animation_at_index()
		finish_sequence()

func animation_finished():
	remove_animation_at_index()
	animation_index += 1
	if animation_index < animation_sequence.size():
		add_animation_at_index()
	else:
		finish_sequence()

func remove_animation_at_index():
	remove_child(get_animation_at_index())

func add_animation_at_index():
	add_child(get_animation_at_index())

func get_animation_at_index():
	return animation_sequence[animation_index]


func finish_sequence():
	LEVEL_TRANSITION.load_current_level()
	queue_free()

func quit_game():
	EMITTER.emit('quit_game')

