extends Node3D
class_name ChessPiece

var black_material_id = "uid://8s4m0g2qja6f"
var white_material_id = "uid://pik18uq4ywa7"

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

var highlighted := false:
	set(value):
		if value:
			highlight.visible = true
		else:
			highlight.visible = false
	
@onready var highlight: MeshInstance3D = $Highlight


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if color == PieceColor.BLACK:
		var material = load(black_material_id)
		$Mesh.material_override = material
	else:
		var material = load(white_material_id)
		$Mesh.material_override = material
	highlight.visible = false
	# connect mouse entered and exit to highlight setter



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	highlighted = true


func _on_mouse_exited() -> void:
	highlighted = false
