extends Node

# This script is responsible for moving its parent. Upon collision, 
# the direction of propagation is changed and the method 'collide_with'
# is called on the parent and the collider is passed as a parameter

# to disable this script, call power_off(), and to bring it back up call power_on()


var move_direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()

var engine_on = false setget set_engine_on

var temp = int(randf() * 100)

# sometimes only one body registers a collision. The following variables are
# used to construct the system that works around that issue.
# The work around needs to do nothing if the collision with the other body has
# already been registered, or will be registered in the future (in this case,
# future = collisions.size() frames). On collision, the array is cleared, and
# the work around does nothing. Every frame current_collision_array_index
# is incremented, if at any point, there is a collision in the collision array 
# that happened collisions.size() frames ago, then this body hasnt cleared its
# collisions and so did not register the collision. If that happens, the missed
# collision is consumed and the body acts as if it has collided with the body
# in the missed collision
var last_collision_frame = 0
var collisions = [null, null, null]
var missed_col_size = collisions.size()
var current_collision_array_index = 0

func _ready():
	power_on()

func power_on():
	clear_registered_collisions()
	if get_parent().has_method('move_and_collide'):
		engine_on = true

func power_off():
	engine_on = false

func set_engine_on(make_on):
	if make_on:
		power_on()
	else:
		power_off()

func _process(delta):
	if !engine_on:
		return
	
	var collision = get_parent().move_and_collide(move_direction * VARIABLES.default_tower_section_speed * delta)
	collision = get_missed_collision_if_no_collision(collision)
	
	if collision:
		last_collision_frame = Engine.get_frames_drawn()
		clear_registered_collisions()
		set_move_direction(collision)
		get_parent().move_and_collide(move_direction * VARIABLES.default_tower_section_speed * delta)
		if get_parent().has_method('collide_with'):
			get_parent().collide_with(collision.collider)
			register_collision_with_collider(collision)

func set_move_direction(collision):
	if is_missed_collision(collision):
		move_direction = collision.new_dir
	else:
		move_direction = move_direction.bounce(collision.normal)

func get_missed_collision_if_no_collision(collision):
	if should_consume_missed_collsion(collision):
		collision = get_oldest_missed_collision()
	increment_collision_array_index()
	return collision

func get_oldest_missed_collision():
	# plus one since it's a circular array, so the oldest item is the next index
	var oldest_col_index = (current_collision_array_index + 1) % missed_col_size
	return collisions[oldest_col_index]

func should_consume_missed_collsion(collision):
	return !collision && get_oldest_missed_collision()


func increment_collision_array_index():
	current_collision_array_index = (current_collision_array_index  + 1) % missed_col_size

func register_collision_with_collider(collision):
	if !is_missed_collision(collision) && collision.collider.is_in_group('has_engine'):
		var missed = MissedCollision.new()
		missed.collider = self
		missed.new_dir = ((collision.collider.position - collision.position)).normalized()
		var angle_difference = collision.collider.get_node('Engine').move_direction.angle_to(missed.new_dir)
		missed.new_dir = missed.new_dir.rotated(-angle_difference / 2)
		collision.collider.get_node('Engine').add_collision(missed)

func add_collision(col):
	var current_frame = Engine.get_frames_drawn()
	if !engine_on || current_frame - last_collision_frame < missed_col_size:
		return
	collisions[current_collision_array_index] = col

func clear_registered_collisions():
	collisions = [null, null, null]

func is_missed_collision(col):
	return 'new_dir' in col

class MissedCollision:
	var collider
	var new_dir
