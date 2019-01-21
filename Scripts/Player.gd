extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 23
const SPEED = 550
const JUMP_HEIGHT = -600
const MAX_HP = 100
const MAX_POWER = 200

onready var sprite = get_node("Sprite")
onready var collision = get_node("CollisionShape2D")
onready var CastR = get_node("CastR")
onready var CastL = get_node("CastL")
onready var CastD = get_node("CastD")
onready var animplayer = get_node("CamLock/Animations")
#sounds
onready var sound = get_node("sounds")

var dash = 0
var dsp = 0
var HP = 100
var power = 100
var jump_time = 0
var motion = Vector2()
var jumping = false
var anim = "Still"
var coll = null
var plat = null
var plat_vel = Vector2()


func _process(delta):
	if !Input.is_action_pressed("ui_left") && !Input.is_action_pressed("ui_right"):
		anim = "Still"
	if jumping:
		anim = "Jump"
	sprite.play(anim)
	
	if HP < 1:
		get_tree().reload_current_scene()
		
	if power > MAX_POWER:
		power = MAX_POWER
	if power < 0:
		power = 0
	
		
	
func _physics_process(delta):
	motion.y += GRAVITY
	
	if Input.is_action_pressed("ui_right"):
		motion.x = SPEED
		anim = "Running"
	elif Input.is_action_pressed("ui_left"):
		motion.x = -SPEED
		anim = "Running"
	else:
		motion.x = 0
	
	if is_on_floor():
		jumping	= false
		get_node("JumpTimer").start()
		motion += get_floor_velocity()*delta
		
	if Input.is_action_just_pressed("gp_jump") && jumping == false:
			motion.y += JUMP_HEIGHT
			sound._play_sound_full(0)
			if get_floor_velocity().y < 0:
				position.y += -600 * delta
			
	if Input.is_action_just_pressed("gp_dash") && (dash == 0) && (power > 9):
		dash = 1
		power -= 10
		sound._play_sound_full(1)
		_cam_shake()
		get_node("DashTimer").start()
		get_node("Poof").emitting = 1
		if (sprite.flip_h == true):
			get_node("Poof").rotation_degrees = 0
			dsp = -(SPEED*10)
		if (sprite.flip_h == false):
			get_node("Poof").rotation_degrees = 180
			dsp = SPEED*10
			
	if dash:
		dsp = dsp*0.85
		if (sprite.flip_h == true):
			motion.x = dsp
		if (sprite.flip_h == false):
			motion.x =dsp
	
	motion = move_and_slide(motion, UP)

	
func _fox_hurt(amnt):
#	sound.play_hurt()
	get_node("Particles2D").emitting = 0
	get_node("Particles2D").emitting = 1
	HP -= amnt
	_cam_shake()
	
func _cam_shake():
	if (!animplayer.current_animation == "CamShake"):
		animplayer.current_animation = "CamShake"
	else:
		animplayer.queue("CamShake")
	pass
	
func _on_JumpTimer_timeout():
	jumping = true
	pass # replace with function body

func _on_DashTimer_timeout():
	if dash != 0:
		dash = 0
	get_node("Poof").emitting = 0
	pass # replace with function body
