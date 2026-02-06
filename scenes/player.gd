extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
const CURRENT_MAX_JUMP = 2
var MAX_JUMPS = CURRENT_MAX_JUMP

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# setting the nb of jump to basic
	if is_on_floor():
		MAX_JUMPS = CURRENT_MAX_JUMP

	# Handle double jump 
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up"):
		if MAX_JUMPS > 0:
			velocity.y = JUMP_VELOCITY
			MAX_JUMPS -= 1
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
