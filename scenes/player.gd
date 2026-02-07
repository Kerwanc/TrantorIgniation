extends CharacterBody2D

const SPEED = 100.0
const MIN_JUMP_POWER = -100.0
const MAX_JUMP_POWER = -700.0
const CHARGE_RATE = 600.0
const SHAKE_INCREASE_RATE = 5.0
const SHAKE_MAX = 2.5

var shake_intensity = 0.0
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

func handle_shake(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		shake_intensity = min(shake_intensity + SHAKE_INCREASE_RATE * delta, SHAKE_MAX)
	
		# Appliquer le tremblement aléatoire
		var shake_offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		$AnimatedSprite2D.offset = shake_offset
	else:
		# Réduire l'intensité quand on relâche
		shake_intensity = max(shake_intensity - SHAKE_INCREASE_RATE * 2 * delta, 0.0)
		$AnimatedSprite2D.offset = Vector2.ZERO
		
func handle_jump(delta : float) -> void:
	handle_landing()
	handle_charge_jump(delta)
	handle_release_jump()
	

func handle_gravity(delta) :
	if not is_on_floor():
		velocity += get_gravity() * delta

func update_velocity() -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func manage_particules_orientation(direction) -> void:
	var particles = $GPUParticles2D
	if direction > 0:
		particles.rotation_degrees = 45
		particles.position.x = -4
	elif direction < 0:
		particles.rotation_degrees = -45
		particles.position.x = 4
	else:
		particles.rotation_degrees = 0
	
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
		$GPUParticles2D.emitting = true
	if velocity.y > 0 :
		$AnimatedSprite2D.play("falling")
		$GPUParticles2D.emitting = false


	
func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_jump(delta)	
	update_velocity()
	handle_shake(delta)
	proccess_animation()
	move_and_slide()
