extends Area2D #when the object first enters the scene

signal hit

@export var speed = 400 #how fast the player will move (pixels/sec)
var screen_size #size of game window


func _ready():
	screen_size = get_viewport_rect().size #makes window correct size
	hide() #hides player at game start


func _process(delta): # Called every frame. Delta is time elapsed
	var velocity = Vector2.ZERO #player's movement vector, starts by not moving (0,0)
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):  #makes character move with keys pressed
		velocity.x += -1
	if Input.is_action_pressed("move_up"):
		velocity.y += -1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1

	if velocity.length() > 0:  #normalizes velocity so you move at equal speeds in all directions
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()  #makes animations play when keys pressed
	else:
		$AnimatedSprite2D.stop() 

	position += velocity * delta #delta ensures movement stays consistent regardless of framerate
	position = position.clamp(Vector2.ZERO, screen_size) #clamp keeps player from moving off-screen

	if velocity.x != 0: #flips the animations for horizontal and vertical movement
		$AnimatedSprite2D.animation = "Walk"  #Using the correct case is important for file names
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "Up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(_body):
	hide() #player disappears after being hit
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true) #set_deferred prevent collision error


func start(pos):  #reset the player when starting new game
	position = pos
	show()
	$CollisionShape2D.disabled = false
