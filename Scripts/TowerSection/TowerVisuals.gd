extends Position2D

signal has_collided

func _ready():
	pass

func collided_with(collider):
	emit_signal('has_collided', collider)
