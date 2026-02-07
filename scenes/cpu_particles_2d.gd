extends CPUParticles2D

@export var max_lifetime: float = 2.0
@export var min_lifetime: float = 0.1

func _process(_delta):
	# Cast ray downward to find ground
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + Vector2(0, 200)  # Check further down
	)
	
	var result = space_state.intersect_ray(query)
	if result:
		# Adjust lifetime based on distance to ground
		var distance_to_ground = result.position.distance_to(global_position)
		# Shorter distance = shorter lifetime
		lifetime = clamp(distance_to_ground / 100.0, min_lifetime, max_lifetime)
	else:
		# No ground found, use max lifetime
		lifetime = max_lifetime
