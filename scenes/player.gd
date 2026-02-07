extends CharacterBody2D

const SPEED = 100.0
const MIN_JUMP_POWER = -100.0
const MAX_JUMP_POWER = -700.0
const CHARGE_RATE = 600.0
const SHAKE_INCREASE_RATE = 5.0
const SHAKE_MAX = 2.5		

@onready var tilemap = get_parent().get_node("AssetsTiles")
@onready var gui = $"../GUILayer/inGameUI"

var shake_intensity = 0.0
var jump_charge = 0.0
var jump_used = false 

signal tomato_power
signal player_died
var dying = false
var death_animation_finished = false
var has_tomato_power = false

func _ready() -> void:
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)

func die():
	if not dying:
		dying = true
		set_physics_process(false)
		$death.emitting = true;
		$AnimatedSprite2D.play("death")

func activate_tomato_power() -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if not has_tomato_power:
		has_tomato_power = true
		$GPUParticles2D.emitting = false
		if direction < 0:
			$TomatoParticles.rotation_degrees = -45
			$TomatoParticles.position.x = 4
		if velocity.y < 0 :
			$TomatoParticles.emitting = true 
		$TomatoPowerTimer.start(10.0)
		tomato_power.emit()


func _on_tomato_power_timer_timeout() -> void:
	has_tomato_power = false
	$TomatoParticles.emitting = false
	tomato_power.emit()
	print("ici")

func _on_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		death_animation_finished = true
		$AnimatedSprite2D.play("death_idle")
		player_died.emit()

func handle_charge_jump(delta : float) -> void :
	if Input.is_action_pressed("ui_accept") and not jump_used:
		jump_charge -= CHARGE_RATE * delta
		if jump_charge < -1500 :
			die()

func handle_release_jump() -> void :
	if Input.is_action_just_released("ui_accept") and not jump_used:
		velocity.y = MIN_JUMP_POWER + clamp(jump_charge, MAX_JUMP_POWER, 0.0)
		jump_charge = 0.0
		jump_used = true

func handle_landing() -> void :
	if is_on_floor() and jump_used:
		jump_used = false
		jump_charge = 0.0

func handle_shake(delta: float) -> void:
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		shake_intensity = min(shake_intensity + SHAKE_INCREASE_RATE * delta, SHAKE_MAX)
		var shake_offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		$AnimatedSprite2D.offset = shake_offset
	else:
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
	var particles = $TomatoParticles if has_tomato_power else $GPUParticles2D
	if direction > 0:
		particles.rotation_degrees = 45
		particles.position.x = -4
	elif direction < 0:
		particles.rotation_degrees = -45
		particles.position.x = 4
	else:
		particles.rotation_degrees = 0
	
func proccess_animation() -> void :
	if dying: 
		return
	var particles = $TomatoParticles if has_tomato_power else $GPUParticles2D
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
		particles.emitting = true
	if velocity.y > 0 :
		$AnimatedSprite2D.play("falling")
		particles.emitting = false

func handle_tiles() -> void :
	var collision = get_last_slide_collision()
	if collision == null:
		return
	var normal = collision.get_normal()
	print(normal)

func handle_flight(delta: float) :
	if Input.is_action_pressed("ui_accept") :
		gui.time_skip(0.1)
		velocity.y = MIN_JUMP_POWER

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	if has_tomato_power :
		handle_flight(delta)
	else :
		handle_jump(delta)	
		handle_shake(delta)
	update_velocity()
	proccess_animation()
	move_and_slide()
