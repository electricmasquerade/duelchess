extends Node

var pieces_by_position: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func convert_grid_to_notation(grid_position: Vector3i):
	# converts grid position to a chess notation string (e.g., (0,0) -> "a1")
	var file: String = char(97 + grid_position.x) # 'a' is ASCII 97
	var rank: String = str(grid_position.z + 1)
	return file + rank
	
func convert_notation_to_grid(notation: String):
	# converts chess notation string to grid position (e.g., "a1" -> (0,0))
	var file: int = int(notation[0].to_ascii_buffer()[0] - 97) # 'a' is ASCII 97
	var rank: int = int(notation.substr(1, notation.length() - 1)) - 8
	return Vector3i(file, 0, rank)

func register_piece(piece: ChessPiece):
	# Registers a chess piece in the manager and notes its position.
	var grid_position: Vector3i = piece.grid_position
	pieces_by_position[grid_position] = piece
	print("Registered piece at position: ", grid_position)
	print(convert_grid_to_notation(grid_position))
	
	pass
