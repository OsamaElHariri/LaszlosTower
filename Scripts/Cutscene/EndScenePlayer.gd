extends Node

var end_scene = load('res://Scenes/Cutscene/EndCutscene.tscn')

func _ready():
	EMITTER.connect('win_game', self, 'on_win_game')

func on_win_game():
	add_child(end_scene.instance())
