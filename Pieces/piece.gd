extends Node3D
class_name ChessPiece

enum PieceType {
	PAWN,
	ROOK,
	KNIGHT,
	BISHOP,
	QUEEN,
	KING
}

enum PieceColor {
	WHITE,
	BLACK
}

@export var type: PieceType
@export var color: PieceColor

var grid_position: Vector3i = Vector3i.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
