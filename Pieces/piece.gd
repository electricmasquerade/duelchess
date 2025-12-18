extends Node3D
class_name Piece

@export var black_material : Material
@export var white_material : Material

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
var has_moved: bool = false

var highlighted := false:
	set(value):
		if value:
			highlight.visible = true
		else:
			highlight.visible = false

var selected := false:
	set(value):
		selected = value
		if not value:
			highlighted = false
			
@onready var highlight: MeshInstance3D = $Highlight

signal hovered(piece: Piece, focused: bool)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if color == PieceColor.BLACK:
		#var material = load(black_material)
		#$Mesh.material_override = material
		$Mesh.material_override = black_material
	else:
		#var material = load(white_material)
		#$Mesh.material_override = material
		$Mesh.material_override = white_material
	highlight.visible = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	if not selected:
		hovered.emit(self, true)
		highlighted = true
	

func _on_mouse_exited() -> void:
	if not selected:
		hovered.emit(self, false)
		highlighted = false
