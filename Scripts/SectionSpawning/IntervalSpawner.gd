extends Position2D

var section_type
var spawn_interval = 5.0

var pending_spawn = false

func _ready():
	$SpawnTimer.connect('timeout', self, 'spawn')

func start():
	# small amount of randomness is added to prevent all the spawners
	# with the same spawn interval to all trigger on the same frame
	# and cause frames to drop
	$SpawnTimer.wait_time = spawn_interval + randf() * 0.2
	$SpawnTimer.start()

func spawn():
	pending_spawn = true

func _process(delta):
	if pending_spawn && can_spawn():
		give_tower_section_to_parent()
		pending_spawn = false
		$SpawnTimer.start()

func can_spawn():
	return $Area2D.get_overlapping_bodies().size() == 0 \
	&& FACTORIES.can_dispense(section_type)

func give_tower_section_to_parent():
	var new_section = FACTORIES.dispense(section_type)
	get_parent().spawn(new_section)
