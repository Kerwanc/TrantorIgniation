extends CharacterBody2D

const SPEED = 100.0
const MIN_JUMP_POWER = -100.0
const MAX_JUMP_POWER = -700.0
const CHARGE_RATE = 600.0

var jump_charge = 0.0
var jump_used = false

func handle_charge_jump(delta : float) -> void :
	if Input.is_action_pressed("ui_accept") and not jump_used:
		jump_charge -= CHARGE_RATE * delta
		jump_charge = clamp(jump_charge, MAX_JUMP_POWER, 0.0)

func handle_release_jump() -> void :
	if Input.is_action_just_released("ui_accept") and not jump_used:
		velocity.y = MIN_JUMP_POWER + jump_charge
		jump_charge = 0.0
		jump_used = true

func handle_landing() -> void :
	if is_on_floor() and jump_used:
		jump_used = false
		jump_charge = 0.0

func handle_jump(delta : float) -> void:
	handle_landing()
	handle_charge_jump(delta)
	handle_release_jump()
	

func handle_gravity(delta) :
	if not is_on_floor():
		velocity += get_gravity() * delta
	# setting the nb of jump to basic
	if is_on_floor():
		MAX_JUMPS = CURRENT_MAX_JUMP

func update_velocity() -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func manage_particules_orientation(direction) -> void :
	if direction > 0:
		$CPUParticles2D.direction = Vector2(-1, -1)
		$CPUParticles2D.position.x = -4
	elif direction < 0:
		$CPUParticles2D.direction = Vector2(1, -1)
		$CPUParticles2D.position.x = 4
	else :
		$CPUParticles2D.direction = Vector2(0, -1)
	
func proccess_animation() -> void :
	var direction := Input.get_axis("ui_left", "ui_right")
	manage_particules_orientation(direction)
	if direction :
		if velocity.y == 0 :
			$AnimatedSprite2D.play("walking")
		$AnimatedSprite2D.flip_h = direction < 0
	else :
		if velocity.y == 0 :
			$AnimatedSprite2D.play("idle")
	if velocity.y < 0 :
		$AnimatedSprite2D.play("flying")
		$CPUParticles2D.emitting = true
	if velocity.y > 0 :
		$AnimatedSprite2D.play("falling")
		$CPUParticles2D.emitting = false


	
func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_jump(delta)	
	update_velocity()
	proccess_animation()
	move_and_slide()
