extends AnimatedSprite2D

var alive = true

func _on_tomato_body_entered(body: Node2D) -> void:
	if alive == true:
		alive = false
		$".".play("death")
