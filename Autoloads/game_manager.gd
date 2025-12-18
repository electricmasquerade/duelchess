extends Node

@onready var chess_manager: Node = $ChessManager
@onready var combat_manager: Node = $CombatManager



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_capture_initiated(attacking_piece: Piece, defending_piece: Piece):
	print("Capture initiated between ", attacking_piece, " and ", defending_piece)
	#combat_manager.start_combat(attacking_piece, defending_piece)