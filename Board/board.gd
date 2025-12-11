extends Node3D

@onready var grid: GridMap = $BoardGrid
var pieces: Array = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# find all pieces, add them to array, give them their grid position
	for node in get_tree().get_nodes_in_group("chess_pieces"):
		#print(node)
		if node is ChessPiece:
			var piece: ChessPiece = node
			pieces.append(piece)
			var grid_position: Vector3i = grid.local_to_map(piece.global_transform.origin)
			piece.grid_position = grid_position
			# Register piece in chess manager
			GameManager.chess_manager.register_piece(piece)
			print("Piece at grid position: ", grid_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
