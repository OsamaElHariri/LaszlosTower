extends Position2D


func _ready():
	var btn_scene = load('res://Scenes/UI/LevelSelectButton.tscn')
	var index = 0
	for lvl in LEVEL_TRANSITION.level_order:
		var new_btn = btn_scene.instance()
		new_btn.set_level_order_index(index)
		$ScrollContainer/VBoxContainer.add_child(new_btn)
		index += 1
