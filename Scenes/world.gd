@tool
extends Node2D

@export var available_tiles: Array[String]

var rooms = []
@onready var map: Node = $Map

func _ready() -> void:
    pass
