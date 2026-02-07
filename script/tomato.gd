extends AnimatedSprite2D

signal tomato_collected(tomato)

var alive = true

func _on_tomato_body_entered(body: Node2D) -> void:
	if alive:
		alive = false
		tomato_collected.emit(self)
		$".".play("death")
