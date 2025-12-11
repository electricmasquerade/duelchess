extends Node3D

@onready var grid: GridMap = $BoardGrid

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for cell in grid.get_used_cells():
		print(cell)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
