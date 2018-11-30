extends Node

enum levels {TutorialCollect, TutorialDiscard, TrainAndPulse, TrainPulseKiosk, TeleportLevel
TrainTeleport, ExplosionLaserTrain, PulseTeleport, LaserTrain, TrainTPLaser, PulseTPExplosion}

var current_level = levels.TutorialCollect

var completed_levels = []

var level_scenes = {
	levels.TutorialCollect: load('res://Scenes/Levels/TutorialCollect.tscn'),
	levels.TutorialDiscard: load('res://Scenes/Levels/TutorialDiscard.tscn'),
	levels.TrainAndPulse: load('res://Scenes/Levels/TrainAndPulseLevel.tscn'),
	levels.TrainPulseKiosk: load('res://Scenes/Levels/TrainPulseKiosk.tscn'),
	levels.TeleportLevel: load('res://Scenes/Levels/TeleportLevel.tscn'),
	levels.TrainTeleport: load('res://Scenes/Levels/TrainAndTeleport.tscn'),
	levels.ExplosionLaserTrain: load('res://Scenes/Levels/ExplosionLaserTrain.tscn'),
	levels.PulseTeleport: load('res://Scenes/Levels/PulseTeleport.tscn'),
	levels.LaserTrain: load('res://Scenes/Levels/LaserTrain.tscn'),
	levels.TrainTPLaser: load('res://Scenes/Levels/TrainTPLaser.tscn'),
	levels.PulseTPExplosion: load('res://Scenes/Levels/PulseTPExplosion.tscn'),
}

var level_order = [levels.TutorialCollect,
levels.TutorialDiscard,
levels.TrainAndPulse, 
levels.TrainPulseKiosk,
levels.TeleportLevel,
levels.TrainTeleport,
levels.PulseTeleport,
levels.LaserTrain,
levels.TrainTPLaser,
levels.PulseTPExplosion,
levels.ExplosionLaserTrain]

func _ready():
	completed_levels = SAVE.get_saved_levels()
	current_level = get_highest_level_reached()
	EMITTER.connect('level_complete', self, 'on_level_complete')

func get_highest_level_reached():
	var highest_index = 0
	for lvl in completed_levels:
		var lvl_index = level_order.find(lvl)
		highest_index = max(highest_index, level_order.find(lvl))
	return level_order[highest_index]


func on_level_complete():
	var current_index = level_order.find(current_level)
	var next_level_index = current_index + 1
	
	if next_level_index >= level_order.size():
		win_game()
	else:
		go_to_level(level_order[next_level_index])

func find_index_of(level):
	return level_order.find(level)

func load_current_level():
	go_to_level(current_level)

func go_to_level_index(index):
	go_to_level(level_order[index])
	
func go_to_level(lvl):
	POWER_UPS.pop_index(0)
	if !completed_levels.has(lvl):
		completed_levels.append(lvl)
		SAVE.save_levels(completed_levels)
		
	current_level = lvl
	EMITTER.emit('load_level', lvl)

func win_game():
	EMITTER.emit('load_level', null)
	EMITTER.emit('win_game')