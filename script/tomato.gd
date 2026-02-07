extends AnimatedSprite2D

var alive = true

func _on_tomato_body_entered(body: Node2D) -> void:
	if alive and body.is_in_group("player"):
		alive = false
		if body.has_method("activate_tomato_power"):
			body.activate_tomato_power()
		$".".play("death")
