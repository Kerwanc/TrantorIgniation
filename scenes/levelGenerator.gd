extends Node

@export var tilemap: TileMap
@export var player: Node2D
@export var chunk_scenes: Array[PackedScene]

const CHUNK_HEIGHT = 19.8
const START_HEIGHT = -20.9
const TILE_SIZE = 16

var highest_generated_chunk := 0

func get_player_chunk() -> int:
	return int(-player.global_position.y / (CHUNK_HEIGHT * TILE_SIZE))

func _process(_delta):
	var player_chunk = get_player_chunk()

	while highest_generated_chunk < player_chunk + 2:
		generate_chunk(highest_generated_chunk)
		highest_generated_chunk += 1

func generate_chunk(chunk_index: int):
	if chunk_index == 0:
		return # first floor already exists

	var chunk_scene = chunk_scenes.pick_random()
	var chunk = chunk_scene.instantiate()

	var y_offset = -(START_HEIGHT + chunk_index * CHUNK_HEIGHT) * TILE_SIZE
	chunk.position = Vector2(0, y_offset)

	tilemap.add_child(chunk)
