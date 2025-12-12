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
	# check legal moves for all pieces
	for piece in pieces:
		var moves = GameManager.chess_manager.find_legal_moves(piece)
		print("Legal moves for piece at ", piece.grid_position, ": ", moves)
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
		print(result)
#		# check if piece is selected and highlight it
#		if result.size() > 0:
#			var collider = result["collider"]
#			if collider is ChessPiece:
#				var piece: ChessPiece = collider
#				piece.highlighted = true
#				print("Piece selected at grid position: ", piece.grid_position)
