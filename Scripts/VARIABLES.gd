extends Node2D

# This class is set up as an autoload node
# This class holds variables, that might need to be tweeked, in one place
# speeds are usually per second (i.e. multiplied by delta on each frame)

# the maximum number of sections allowed in the tower
var max_sections = 4

var initial_scale_multiplier = 0.35

# the speed at which the tower  sections move in the levels
var default_tower_section_speed = 190

# the speed of rotation of the tower sections
var tower_section_rotation_speed = deg2rad(30)

# how much larger the tower section at level N is from the one at level N - 1
# So the fourth tower section's scale = (third tower section scale) + tower_section_scale_multiplier
var tower_section_scale_multiplier = 0.11

# the point at which the light is coming from, used to determine rotaion
# of the light on some sprites
var light_point = Vector2(-200, 445)

# updated each frame by the tower
var current_tower_position = Vector2(0, 0)

# used to mute/ unmute background music
var play_background_loop = true

# used to mute/ unmute sound effects
var play_sfx = true


