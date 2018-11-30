extends Position2D

var shake_timer
var shake_cam = false

func _ready():
	shake_timer = Timer.new()
	shake_timer.wait_time = 0.15
	shake_timer.one_shot = true
	shake_timer.connect('timeout', self, 'stop_shake')
	add_child(shake_timer)
	
	EMITTER.connect('camera_shake', self, 'shake')


func _process(delta):
	if !shake_cam:
		return
		
	var shake_amount = 6.0
	$Camera2D.set_offset(Vector2( \
        rand_range(-1.0, 1.0) * shake_amount, \
        rand_range(-1.0, 1.0) * shake_amount \
    ))

func shake():
	shake_cam = true
	shake_timer.start()

func stop_shake ():
	shake_cam = false
	$Camera2D.set_offset(Vector2(0, 0))