extends Node

@export var tilemap: TileMap
@export var player: Node2D
@export var chunk_scenes: Array[PackedScene]
@export var ending: PackedScene

const CHUNK_HEIGHT = 19.8
const START_HEIGHT = -20.9
const CHUNK_BEFORE_END = 2
const TILE_SIZE = 16

var highest_generated_chunk := 0
var chunk_remaining = CHUNK_BEFORE_END

func get_player_chunk() -> int:
	return int(-player.global_position.y / (CHUNK_HEIGHT * TILE_SIZE))

func _process(_delta):
	var player_chunk = get_player_chunk()

	while highest_generated_chunk < player_chunk + 2 and chunk_remaining > 0:
		generate_chunk(highest_generated_chunk)
		highest_generated_chunk += 1
		chunk_remaining -= 1
	if chunk_remaining == 0:
		generate_the_end(highest_generated_chunk)
		chunk_remaining = -1

func generate_the_end(chunk_index: int) -> void: 
	
	var chunk = ending.instantiate()

	var y_offset = -(START_HEIGHT + chunk_index * CHUNK_HEIGHT) * TILE_SIZE
	chunk.position = Vector2(0, y_offset)

	tilemap.add_child(chunk)

func generate_chunk(chunk_index: int):
	if chunk_index == 0:
		return # first floor already exists

	var chunk_scene = chunk_scenes.pick_random()
	var chunk = chunk_scene.instantiate()

	var y_offset = -(START_HEIGHT + chunk_index * CHUNK_HEIGHT) * TILE_SIZE
	chunk.position = Vector2(0, y_offset)

	tilemap.add_child(chunk)
