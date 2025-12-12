extends Node3D
# Note: let chess manager update all positions, just move pieces visually here
@onready var grid: GridMap = $BoardGrid
var pieces: Array = []
var markers: Array = []

var selected_piece: Piece = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# find all pieces, add them to array, give them their grid position
	for node in get_tree().get_nodes_in_group("chess_pieces"):
		#print(node)
		if node is Piece:
			var piece: Piece = node
			pieces.append(piece)
			var grid_position: Vector3i = grid.local_to_map(piece.global_transform.origin)
			piece.grid_position = grid_position
			# Register piece in chess manager
			GameManager.chess_manager.register_piece(piece)
			print("Piece at grid position: ", grid_position)
			piece.hovered.connect(_on_piece_hovered)
			



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		print("Click detected")
		# cast ray from camera to mouse position
		var space_state = get_world_3d().direct_space_state
		var cam = get_viewport().get_camera_3d()
		var mouse_pos = get_viewport().get_mouse_position()
		var origin = cam.project_ray_origin(mouse_pos)
		var end = origin + cam.project_ray_normal(mouse_pos) * 1000
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		query.collide_with_areas = true
	
		var result = space_state.intersect_ray(query)
		#print(result)
		# select piece if ray hits one
		if result and result.has("collider"):
			var collider = result["collider"]
			print(collider)
			if collider is Piece:
				_on_piece_clicked(collider)
				
			elif collider is GridMap:

				# get square and check if it is valid move for current piece
				if selected_piece != null:
					var grid_position: Vector3i = grid.local_to_map(result["position"])
					var legal_moves: Array = GameManager.chess_manager.find_legal_moves(selected_piece)
					print(grid_position)
					print(legal_moves)
					if grid_position in legal_moves:
						print("legal")
						# move pieces and update chess manager
						GameManager.chess_manager.move_piece(selected_piece, grid_position)
						#update piece position visually
						var world_position: Vector3 = grid.map_to_local(grid_position) + Vector3(0, 0.5, 0)
						selected_piece.global_transform.origin = world_position
						selected_piece.grid_position = grid_position
						#end turn
						#GameManager.chess_manager.end_turn()
						deselect_current_piece()
						
				#deselect current piece
					deselect_current_piece()
			else:
				deselect_current_piece()



func highlight_legal_moves(moves: Array) -> void:
	clear_move_markers()
	# place markers on the board for each legal move
	for move in moves:
		#create placeholder sphere
		var marker: MeshInstance3D = MeshInstance3D.new()
		marker.mesh = SphereMesh.new()
		marker.scale = Vector3.ONE * 0.2
		var material: StandardMaterial3D = StandardMaterial3D.new()
		material.albedo_color = Color(0.0, 1.0, 0.0, 0.263)
		marker.material_override = material
		# position marker
		var world_position: Vector3 = grid.map_to_local(move) + Vector3(0, 0.1, 0)
		add_child(marker)
		marker.global_transform.origin = world_position
		markers.append(marker)

func _on_piece_clicked(piece: Piece) -> void:
	print("Piece clicked: ", piece)
	# Deselect current piece if any
	if selected_piece == piece:
		deselect_current_piece()
		return
	
	if selected_piece != null:
		deselect_current_piece()
	# Select new piece
	selected_piece = piece
	piece.selected = true
	piece.highlighted = true
	# Find and highlight legal moves
	var legal_moves: Array = GameManager.chess_manager.find_legal_moves(piece)
	highlight_legal_moves(legal_moves)

func deselect_current_piece() -> void:
	if selected_piece != null:
		selected_piece.selected = false
		selected_piece.highlighted = false
		selected_piece = null
	clear_move_markers()
	
func clear_move_markers() -> void:
	for marker in markers:
		marker.queue_free()
	markers.clear()
	
func _on_piece_hovered(piece: Piece, focused: bool) -> void:
	# Handle piece hover events if needed
	if selected_piece != null:
		return
	if focused:
		var moves: Array = GameManager.chess_manager.find_legal_moves(piece)
		highlight_legal_moves(moves)
	else:
		clear_move_markers()
