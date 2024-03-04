extends KinematicBody2D

export (int) var run_speed = 40
export (int) var jump_speed = -130
export (int) var gravity = 400

var tiles
var sprite
var velocity = Vector2()
var jumping = false

func _ready():
	tiles = get_parent().get_node("Map")
	sprite = $"Sprite"

func get_input():
	velocity.x = 0
	if Input.is_action_just_pressed("nokia_2") and is_on_floor():
		jumping = true
		velocity.y = jump_speed
		# Reset the anim after a jump
		if sprite.animation == "jump":
			sprite.set_frame(0)
		sprite.play("jump")
	if Input.is_action_pressed("nokia_6"):
		velocity.x += run_speed
		sprite.play("walk_right")
	if Input.is_action_pressed("nokia_4"):
		velocity.x -= run_speed
		sprite.play("walk_left")
	# Play animation until release	
	if Input.is_action_just_released("nokia_4") or Input.is_action_just_released("nokia_6"):
		sprite.stop()

func _physics_process(delta):
	get_input()
	tiles.check_event()
	
	if is_on_ceiling() and not jumping:
		tiles.check_collision()
	
	velocity.y += gravity * delta
	
	if jumping and is_on_floor():
		jumping = false
	
	# Stop the animation
	if not sprite.playing:
		sprite.play("default")
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
