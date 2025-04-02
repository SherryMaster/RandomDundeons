@tool
extends Sprite2D

class_name Tile

@export_tool_button("Show Gates") var show_gates: Callable = get_tile_gates

@onready var tile_area: Area2D = $TileArea
@onready var tile_gates: Node2D = $TileGates


func _ready() -> void:
	pass

func get_tile_gates() -> Array:
	print(tile_gates.get_children())
	return tile_gates.get_children()