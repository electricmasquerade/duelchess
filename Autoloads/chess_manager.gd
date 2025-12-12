extends Node

var pieces_by_position: Dictionary = {}
# store movement vectors for each piece type
var movement_vectors

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func convert_grid_to_notation(grid_position: Vector3i):
	# converts grid position to a chess notation string (e.g., (0,0) -> "a1")
	var file: String = char(97 + grid_position.x) # 'a' is ASCII 97
	var rank: String = str(8 - grid_position.z)
	return file + rank
	
func convert_notation_to_grid(notation: String):
	# converts chess notation string to grid position (e.g., "a1" -> (0,0))
	var file: int = int(notation[0].to_ascii_buffer()[0] - 97) # 'a' is ASCII 97
	var rank: int = 8 - int(notation.substr(1, notation.length() - 1))
	return Vector3i(file, 0, rank)

func register_piece(piece: ChessPiece):
	# Registers a chess piece in the manager and notes its position.
	var grid_position: Vector3i = piece.grid_position
	pieces_by_position[grid_position] = piece
	print("Registered piece at position: ", grid_position)
	print(convert_grid_to_notation(grid_position))
	

func find_legal_moves(piece: ChessPiece):
	# Placeholder for legal move calculation logic.
	var legal_moves: Array = []
	var potential_moves: Array = []
	# Implement specific movement rules based on piece type and color.
	match piece.type:
		ChessPiece.PieceType.PAWN:
			# get valid moves for pawn and then filter by color, captures, etc.
			potential_moves = get_movement_vectors(piece.type)
			if piece.color == ChessPiece.PieceColor.WHITE:
				for i in range(potential_moves.size()):
					potential_moves[i] = -potential_moves[i]
			for move in potential_moves:
				var target_position = piece.grid_position + move
				# TODO: check for target validity
				if not pieces_by_position.has(target_position):
					legal_moves.append(target_position)
			
		ChessPiece.PieceType.ROOK:
			movement_vectors = get_movement_vectors(piece.type)
			# check all four directions until blocked
			for vector in movement_vectors:
				var step: int = 1
				while true:
					var target_position = piece.grid_position + vector * step
					if pieces_by_position.has(target_position):
						# check if piece at target is opponent's piece for capture
						var target_piece: ChessPiece = pieces_by_position[target_position]
						if target_piece.color != piece.color:
							legal_moves.append(target_position)
						break
					legal_moves.append(target_position)
					step += 1
					if step > 7:
						break
		ChessPiece.PieceType.KNIGHT:
			potential_moves = get_movement_vectors(piece.type)
			for move in potential_moves:
				var target_position = piece.grid_position + move
				# check for target validity
				if not pieces_by_position.has(target_position):
					legal_moves.append(target_position)
				else:
					var target_piece: ChessPiece = pieces_by_position[target_position]
					if target_piece.color != piece.color:
						legal_moves.append(target_position)
		ChessPiece.PieceType.BISHOP:
			# basically same as rook tbh
			movement_vectors = get_movement_vectors(piece.type)
			# check all four diagonal directions until blocked
			for vector in movement_vectors:
				var step: int = 1
				while true:
					var target_position = piece.grid_position + vector * step
					if pieces_by_position.has(target_position):
						# check if piece at target is opponent's piece for capture
						var target_piece: ChessPiece = pieces_by_position[target_position]
						if target_piece.color != piece.color:
							legal_moves.append(target_position)
						break
					legal_moves.append(target_position)
					step += 1
					if step > 7:
						break
		ChessPiece.PieceType.QUEEN:
			# just rook and bishop
			movement_vectors = get_movement_vectors(piece.type)
			# check all eight directions until blocked
			for vector in movement_vectors:
				var step: int = 1
				while true:
					var target_position = piece.grid_position + vector * step
					if pieces_by_position.has(target_position):
						# check if piece at target is opponent's piece for capture
						var target_piece: ChessPiece = pieces_by_position[target_position]
						if target_piece.color != piece.color:
							legal_moves.append(target_position)
						break
					legal_moves.append(target_position)
					step += 1
					if step > 7:
						break
		ChessPiece.PieceType.KING:
			for vector in get_movement_vectors(piece.type):
				var target_position = piece.grid_position + vector
				# check for target validity
				if not pieces_by_position.has(target_position):
					legal_moves.append(target_position)
				else:
					var target_piece: ChessPiece = pieces_by_position[target_position]
					if target_piece.color != piece.color:
						legal_moves.append(target_position)
			
	# remove all valid moves that are off the board
	legal_moves = legal_moves.filter(func(pos):
		return pos.x >= 0 and pos.x < 8 and pos.z >= 0 and pos.z < 8
	)
	return legal_moves


func get_movement_vectors(type: ChessPiece.PieceType):
	# Returns movement vectors for the given piece type.
	match type:
		ChessPiece.PieceType.PAWN:
			return [Vector3i(0, 0, 1)]
		ChessPiece.PieceType.ROOK:
			return [Vector3i(1, 0, 0), Vector3i(-1, 0, 0), Vector3i(0, 0, 1), Vector3i(0, 0, -1)]
		ChessPiece.PieceType.KNIGHT:
			return [Vector3i(1, 0, 2), Vector3i(1, 0, -2), Vector3i(-1, 0, 2), Vector3i(-1, 0, -2),
					Vector3i(2, 0, 1), Vector3i(2, 0, -1), Vector3i(-2, 0, 1), Vector3i(-2, 0, -1)]
		ChessPiece.PieceType.BISHOP:
			return [Vector3i(1, 0, 1), Vector3i(1, 0, -1), Vector3i(-1, 0, 1), Vector3i(-1, 0, -1)]
		ChessPiece.PieceType.QUEEN:
			return [Vector3i(1, 0, 0), Vector3i(-1, 0, 0), Vector3i(0, 0, 1), Vector3i(0, 0, -1),
					Vector3i(1, 0, 1), Vector3i(1, 0, -1), Vector3i(-1, 0, 1), Vector3i(-1, 0, -1)]
		ChessPiece.PieceType.KING:
			return [Vector3i(1, 0, 0), Vector3i(-1, 0, 0), Vector3i(0, 0, 1), Vector3i(0, 0, -1),
					Vector3i(1, 0, 1), Vector3i(1, 0, -1), Vector3i(-1, 0, 1), Vector3i(-1, 0, -1)]
	return []
