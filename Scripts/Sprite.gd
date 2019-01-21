extends AnimatedSprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		flip_h = 1
	elif Input.is_action_just_pressed("ui_right"):
		flip_h = 0