extends KinematicBody2D

var movement = Vector2()
var CanMove = true
var CanDash = true
var isDead = false

func _physics_process(delta):

	#Go back to menu, definitely shouldn't be here but it didn't work in _ready damnit
	if Input.is_action_pressed("pause"):
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
		
	# left and right movement
	if CanMove:
		if Input.is_action_pressed("move_left"):
			if movement.x > -80:
				movement.x -= 20
			$Herself.flip_h = true
			if is_on_floor():
				$Herself.animation = "run"
		elif Input.is_action_pressed("move_right"):
			if movement.x < 80:
				movement.x += 20
			$Herself.flip_h = false
			if is_on_floor():
				$Herself.animation = "run"
		else:
			movement.x = 0
			if is_on_floor():
				$Herself.animation = "idle"
			if Input.is_action_pressed("crouch"):
				$Herself.animation = "crouch"
				$MadelineNoises.stream = load("res://SFx/duck_01.wav")
				$MadelineNoises.play()
				print("quack")

	#Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			movement.y = -300
			$MadelineNoises.stream = load("res://SFx/jump.wav")
			$MadelineNoises.play()
			$Herself.animation = "jump"
			print("Attempted to jump")

	#wall jump
	if !is_on_floor() and is_on_wall() and Input.is_action_just_pressed("jump"):
		movement.y = -300
		if $Herself.flip_h:
			movement.x = 80
			$Herself.flip_h = false
		else:
			movement.x = -80
			$Herself.flip_h = true
		CanMove = false
		$Herself.animation = "jump"
		$WalkTimer.start()
		$MadelineNoises.stream = load("res://SFx/jump_wall.wav")
		$MadelineNoises.play()

	#Stop jumping
	if Input.is_action_just_released("jump") and movement.y < 0:
		movement.y = -100

	#falling
	movement.y += 20

	#limits
	if movement.y > 300:
		movement.y = 300
		
	#floor resets
	if is_on_floor():
		$Hair.modulate = Color (1,0,0)
		CanDash = true

	#Dashing
	if Input.is_action_just_pressed("dash") and CanDash and CanMove:
		$Hair.modulate = Color (0,0,1)
		CanDash = false
		$Herself.animation = "dash"
		movement.x = 0
		movement.y = 0
		CanMove = false
		$WalkTimer.start()
		$MadelineNoises.stream = load("res://SFx/dash.wav")
		$MadelineNoises.play()
		if Input.is_action_pressed("move_left"):
			movement.x = -300
			$Herself.flip_h = true
		if Input.is_action_pressed("move_right"):
			movement.x = 300
			$Herself.flip_h = false
		if Input.is_action_pressed("look_up"):
			movement.y = -300
		if Input.is_action_pressed("crouch"):
			movement.y = 300
		if !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right") and !Input.is_action_pressed("look_up") and !Input.is_action_pressed("crouch"):
			if $Herself.flip_h:
				movement.x = -300
			else:
				movement.x = 300
				
	if isDead:
		movement.x = 0
		movement.y = 0

	movement = move_and_slide(movement, Vector2.UP)

func _WalkCooldownUp():
	CanMove = true

func _on_KillPlane_enter(body):
	print("Madeline died :c")
	$Hair.hide()
	CanMove = false
	isDead = true
	$Herself.animation = "death"
	$MadelineNoises.stream = load("res://SFx/death.wav")
	$MadelineNoises.play()
	$RespawnTimer.start()


func Respawn():
	self.position.x = 0
	self.position.y = 0
	$MadelineNoises.stream = load("res://SFx/revive.wav")
	$MadelineNoises.play()
	isDead = false
	CanMove = true
	$Hair.show()
	$Herself.flip_h = false
	$Herself.animation = "idle"
	print("Madeline is alive! :D")
