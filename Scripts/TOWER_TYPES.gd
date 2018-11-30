extends Node2D

# Autoload that exposes the tower types as an enum
# Tower types means the power ups                                                                                                                                                                                                                                                                                                                                                                                                                             
 
enum types {TRAIN, TELEPORT, LASER, PULSE, SHIELD, EXPLOSION} 

var type_scenes = {
	types.EXPLOSION: load('res://Scenes/PowerUps/Explosion.tscn'),
	types.TRAIN: load('res://Scenes/PowerUps/Train.tscn'),
	types.TELEPORT: load('res://Scenes/PowerUps/Teleport.tscn'),
	types.LASER: load('res://Scenes/PowerUps/LaserBeam.tscn'),
	types.PULSE: load('res://Scenes/PowerUps/Pulse.tscn'),
	types.SHIELD: load('res://Scenes/PowerUps/Shield.tscn'),
}

func get_information(tower_type):
	var temp_scene = type_scenes[tower_type].instance()
	var info = {}
	info['symbol'] = temp_scene.type_symbol
	info['name'] = temp_scene.type_name
	info['description'] = temp_scene.type_description
	temp_scene.queue_free()
	return info