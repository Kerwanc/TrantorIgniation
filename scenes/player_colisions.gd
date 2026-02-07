extends Area2D

@onready var tilemap: TileMap = get_tree().get_first_node_in_group("tilemap")
@onready var player = get_parent()

func _ready() -> void:
	if tilemap == null or player == null:
		print("Y A PAS DE TILES OU DE PLAYER")

func _physics_process(_delta): 
	if player.velocity.y >= 0:
		return
	if tilemap == null:
		return
	var pos = global_position
	var local_pos = tilemap.to_local(pos)
	var cell = tilemap.local_to_map(local_pos)
	var alt_id = tilemap.get_cell_atlas_coords(0, cell)
	if alt_id != Vector2i(-1, -1):
		print(alt_id)
		print("HEAD HIT tile at:", cell)
