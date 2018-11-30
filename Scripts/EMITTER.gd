extends Node2D

# This class is set up as an autoload node.
# Every thing that needs to emit or connect to signals should do it through
# this class. To connect to a signal call EMITTER.connect, where connect
# is the usual signal connecting method. To emit a signal,
# call EMITTER.emit(data), where data is whatever information you want to send
# with the signal

signal start_spawning
signal request_add_section
signal power_up_destroyed
signal level_complete
signal load_level
signal game_start
signal quit_game
signal restart_game
signal win_game
signal camera_shake


func emit (signl, data=null):
	if data !=null:
		emit_signal(signl, data)
	else:
		emit_signal(signl)