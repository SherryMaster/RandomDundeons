@tool
extends Sprite2D
class_name TileGate
enum GateType {ENTER, EXIT, ANY}

@export var type: GateType = GateType.ANY:
	set(value):
		type = value
		match value:
			GateType.ENTER:
				modulate = ENTER_COLOR
			GateType.EXIT:
				modulate = EXIT_COLOR
			GateType.ANY:
				modulate = ANY_COLOR
		

const ENTER_COLOR = Color(0.5, 1, 0.5)
const EXIT_COLOR = Color(0.8, 0.5, 0.5)
const ANY_COLOR = Color(1, 1, 1)

func _process(_delta: float) -> void:
	pass
