extends Node

@onready var timer_label: Label = $TimerLabel
@onready var player = $%Player

var timer: float = 300
var timer_ended: bool = false

func format_time(time: float) -> String:
	var min: int = time / 60
	var sec: String = str(time - min * 60).pad_decimals(0)
	if sec.length() < 2:
		sec = "0" + sec
	return str(min) + ":" + sec

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func time_skip(delay: float) -> void:
	timer -= delay

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (timer_ended == false):	
		timer -= delta
	if (timer <= 0):
		timer = 0
		player.die()
		timer_ended = true
	timer_label.text = "Timer: " + format_time(timer)
