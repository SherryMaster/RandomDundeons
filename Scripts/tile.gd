@tool
extends Node2D

class_name Tile

enum Type {START, HALLWAY, ROOM, TURN}
enum Size {SMALL, MEDIUM, LARGE}

var entrance: TileGate
var exit: TileGate

@export_tool_button("Test Function") var show_gates: Callable = get_wall_cords

@onready var tile_area: Area2D = $TileArea
@onready var tile_gates: Node2D = $TileGates
@onready var tile_floor: TileMapLayer = $Floor
@onready var tile_walls: TileMapLayer = $Walls

func _ready() -> void:
	if not Engine.is_editor_hint():
		set_entrance_and_exit()

func get_tile_gates() -> Array:
	return tile_gates.get_children()

func get_wall_cords() -> Array[Vector2i]:
	return tile_walls.get_used_cells()

func set_entrance_and_exit() -> void:
	var gates: Array[TileGate] = get_tile_gates()
	if gates.size() == 0:
		return
	
	var entrances: Array[TileGate] = gates.filter(func(gate): return gate.type == TileGate.GateType.ENTER)
	var exits: Array[TileGate] = gates.filter(func(gate): return gate.type == TileGate.GateType.EXIT)

	entrance = entrances.pick_random()
	exit = exits.pick_random()

