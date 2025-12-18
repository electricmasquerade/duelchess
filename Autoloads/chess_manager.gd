extends Node

enum Turn{
	WHITE,
	BLACK
}

var current_turn := Turn.WHITE
var turn_num : int = 0
var pieces_by_position: Dictionary = {}
# store movement vectors for each piece type
var movement_vectors

signal capture_initiated(attacking_piece: Piece, defending_piece: Piece)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#connect to game manager
	capture_initiated.connect(GameManager.on_capture_initiated)
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

func register_piece(piece: Piece):
	# Registers a chess piece in the manager and notes its position.
	var grid_position: Vector3i = piece.grid_position
	pieces_by_position[grid_position] = piece
	print("Registered piece at position: ", grid_position)
	print(convert_grid_to_notation(grid_position))
	

func find_legal_moves(piece: Piece):
	#print("=== Finding legal moves for ", piece.type, " at ", piece.grid_position, " ===")
	#print("All pieces positions: ", pieces_by_position.keys())

	# Placeholder for legal move calculation logic.
	var legal_moves: Array = []
	var potential_moves: Array = []
	# Implement specific movement rules based on piece type and color.
	match piece.type:
		Piece.PieceType.PAWN:
			# get valid moves for pawn and then filter by color, captures, etc.
			potential_moves = get_movement_vectors(piece.type)
			if piece.color == Piece.PieceColor.WHITE:
				for i in range(potential_moves.size()):
					potential_moves[i] = -potential_moves[i]
					# add potential moves for first move (two squares forward)
				if not piece.has_moved:
					potential_moves.append(Vector3i(0, 0, -2))
			else:
				# black pawns move "down" the board
				# add potential moves for first move (two squares forward)
				if not piece.has_moved:
					potential_moves.append(Vector3i(0, 0, 2))
			for move in potential_moves:
				var target_position = piece.grid_position + move
				
				if not pieces_by_position.has(target_position):
					legal_moves.append(target_position)
			
		Piece.PieceType.ROOK:
			movement_vectors = get_movement_vectors(piece.type)
			# check all four directions until blocked by either color piece
			for vector in movement_vectors:
				var step: int = 1
				while step <= 7:
					var target_position = piece.grid_position + vector * step
					if target_position.x < 0 or target_position.x >= 8 or target_position.z < 0 or target_position.z >= 8:
						break
					if pieces_by_position.has(target_position):
						# check if piece at target is opponent's piece for capture
						var target_piece: Piece = pieces_by_position[target_position]
						if target_piece.color != piece.color:
							legal_moves.append(target_position)
						break
						
					legal_moves.append(target_position)
					step += 1
					
		Piece.PieceType.KNIGHT:
			potential_moves = get_movement_vectors(piece.type)
			for move in potential_moves:
				var target_position = piece.grid_position + move
				# check for target validity
				if not pieces_by_position.has(target_position):
					legal_moves.append(target_position)
				else:
					var target_piece: Piece = pieces_by_position[target_position]
					if target_piece.color != piece.color:
						legal_moves.append(target_position)
		Piece.PieceType.BISHOP:
			# basically same as rook tbh
			movement_vectors = get_movement_vectors(piece.type)
			# check all four diagonal directions until blocked
			for vector in movement_vectors:
				var step: int = 1
				while step <= 7:
					var target_position = piece.grid_position + vector * step
					if target_position.x < 0 or target_position.x >= 8 or target_position.z < 0 or target_position.z >= 8:
						break
					if pieces_by_position.has(target_position):
						# check if piece at target is opponent's piece for capture
						var target_piece: Piece = pieces_by_position[target_position]
						if target_piece.color != piece.color:
							legal_moves.append(target_position)
						break
					legal_moves.append(target_position)
					step += 1
					
		Piece.PieceType.QUEEN:
			# just rook and bishop
			movement_vectors = get_movement_vectors(piece.type)
			# check all eight directions until blocked
			for vector in movement_vectors:
				var step: int = 1
				while step <= 7:
					var target_position = piece.grid_position + vector * step
					if pieces_by_position.has(target_position):
						# check if piece at target is opponent's piece for capture
						var target_piece: Piece = pieces_by_position[target_position]
						if target_piece.color != piece.color:
							legal_moves.append(target_position)
						break
					legal_moves.append(target_position)
					step += 1
					if step > 7:
						break
		Piece.PieceType.KING:
			for vector in get_movement_vectors(piece.type):
				var target_position = piece.grid_position + vector
				# check for target validity
				if not pieces_by_position.has(target_position):
					legal_moves.append(target_position)
				else:
					var target_piece: Piece = pieces_by_position[target_position]
					if target_piece.color != piece.color:
						legal_moves.append(target_position)
			
	# remove all valid moves that are off the board
	legal_moves = legal_moves.filter(func(pos):
		return pos.x >= 0 and pos.x < 8 and pos.z >= 0 and pos.z < 8
	)
	# reset values of y to 0
	for i in range(legal_moves.size()):
		legal_moves[i].y = 0
	return legal_moves


func get_movement_vectors(type: Piece.PieceType):
	# Returns movement vectors for the given piece type.
	match type:
		Piece.PieceType.PAWN:
			return [Vector3i(0, 0, 1)]
		Piece.PieceType.ROOK:
			return [Vector3i(1, 0, 0), Vector3i(-1, 0, 0), Vector3i(0, 0, 1), Vector3i(0, 0, -1)]
		Piece.PieceType.KNIGHT:
			return [Vector3i(1, 0, 2), Vector3i(1, 0, -2), Vector3i(-1, 0, 2), Vector3i(-1, 0, -2),
					Vector3i(2, 0, 1), Vector3i(2, 0, -1), Vector3i(-2, 0, 1), Vector3i(-2, 0, -1)]
		Piece.PieceType.BISHOP:
			return [Vector3i(1, 0, 1), Vector3i(1, 0, -1), Vector3i(-1, 0, 1), Vector3i(-1, 0, -1)]
		Piece.PieceType.QUEEN:
			return [Vector3i(1, 0, 0), Vector3i(-1, 0, 0), Vector3i(0, 0, 1), Vector3i(0, 0, -1),
					Vector3i(1, 0, 1), Vector3i(1, 0, -1), Vector3i(-1, 0, 1), Vector3i(-1, 0, -1)]
		Piece.PieceType.KING:
			return [Vector3i(1, 0, 0), Vector3i(-1, 0, 0), Vector3i(0, 0, 1), Vector3i(0, 0, -1),
					Vector3i(1, 0, 1), Vector3i(1, 0, -1), Vector3i(-1, 0, 1), Vector3i(-1, 0, -1)]
	return []

func end_turn():
	# Switches the current turn to the other player.
	if current_turn == Turn.WHITE:
		current_turn = Turn.BLACK
	else:
		current_turn = Turn.WHITE
	print("Turn ended. Current turn: ", current_turn)
	
func move_piece(piece: Piece, target_position: Vector3i):
	# Moves a piece to a new position if the move is legal.
	var legal_moves: Array = find_legal_moves(piece)
	# TODO: handle captures
	if target_position in legal_moves:
		#check for capture first
		if pieces_by_position.has(target_position):
			var captured_piece: Piece = pieces_by_position[target_position]
			capture_initiated.emit(piece, captured_piece)
			# remove captured piece from tracking
			pieces_by_position.erase(target_position)
			captured_piece.queue_free()
			print("Captured piece at: ", target_position)
		# Update internal tracking
		pieces_by_position.erase(piece.grid_position)
		piece.grid_position = target_position
		pieces_by_position[target_position] = piece
		print("Moved piece to: ", target_position)
		piece.has_moved = true
	else:
		print("Illegal move attempted to: ", target_position)
