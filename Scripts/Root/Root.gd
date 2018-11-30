extends Node2D

func _ready():
	randomize()
	
	EMITTER.connect('quit_game', self, 'quit_game')
	EMITTER.connect('restart_game', self, 'restart_game')

func quit_game():
	get_tree().quit()

func restart_game():
	get_tree().reload_current_scene()
