extends Node2D

var mouse_block_scene = load('res://Scenes/LevelChunks/MouseBlocker.tscn')

var freed_block = false
var block

func _ready():
	get_parent().get_node('Tower/Engine').move_direction = Vector2(0, 1)
	EMITTER.connect('request_add_section', self, 'show_mouse_block')
	POWER_UPS.connect('selected_index_changed', self, 'show_click_text')
	POWER_UPS.connect('power_ups_changed', self, 'check_changes')
	get_parent().get_node('PowerUpsPanel/LevelLabel').visible = false

func show_mouse_block(section):
	block = mouse_block_scene.instance()
	block.position = Vector2(9, -105)
	get_parent().add_child(block)

func show_click_text():
	block.get_node('ClickToActivate').visible = true

func _process(delta):
	if !freed_block && POWER_UPS.is_depleted(0):
		freed_block = true
		block.queue_free()
	
func check_changes():
	get_parent().get_node('ClickOnPowerUp').visible = false
	if !freed_block && !POWER_UPS.is_power_up(0):
		LEVEL_TRANSITION.load_current_level()
