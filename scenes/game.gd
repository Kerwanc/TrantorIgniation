extends Node2D

@onready var menu_button = $GameOverLayer/MenuButton

func _ready() -> void:
	$GameOverLayer.visible = false
	$Player.player_died.connect(_on_player_died)
	menu_button.pressed.connect(_on_menu_button_pressed)
	
	$tomato.get_node("AnimatedSprite2D").tomato_collected.connect(_on_tomato_collected)

func _on_tomato_collected(tomato_node) -> void:
	$Player.activate_tomato_power()

func _on_player_died() -> void:
	$GameOverLayer.visible = true

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
