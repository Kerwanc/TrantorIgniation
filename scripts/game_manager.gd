extends Node

@onready var timer_label: Label = $TimerLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer_label.text = "Timer: " + str($Timer.time_left).pad_decimals(0)
