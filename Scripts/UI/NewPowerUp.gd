extends Position2D

export(preload('res://Scripts/TOWER_TYPES.gd').types) var section_type

func _ready():
	var power_up_info = TOWER_TYPES.get_information(section_type)
	$Labels/Symbol.texture = power_up_info.symbol
	$Labels/PowerUpName.text = power_up_info.name
	$Labels/Description.text = power_up_info.description
	$AnimationPlayer.play('FadeInOut')
