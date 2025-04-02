@tool
extends Node2D

class_name TileWalls

var pos: Vector2
var rot: float

@onready var n: Wall = $N
@onready var e: Wall = $E
@onready var w: Wall = $W
@onready var s: Wall = $S
@onready var ne: Wall = $NE
@onready var se: Wall = $SE
@onready var nw: Wall = $NW
@onready var sw: Wall = $SW

@export var wall_up: bool = false:
    set(value):
        wall_up = value
        update_walls()

@export var wall_right: bool = false:
    set(value):
        wall_right = value
        update_walls()

@export var wall_down: bool = false:
    set(value):
        wall_down = value
        update_walls()

@export var wall_left: bool = false:
    set(value):
        wall_left = value
        update_walls()

@export var textures: Dictionary[Wall.Type, Texture2D] = {
    Wall.Type.CENTER: null,
    Wall.Type.END: null,
    Wall.Type.NO_END: null,
    Wall.Type.CORNER: null
}:
    set(value):
        textures = value
        if is_inside_tree():
            apply_textures()

func _ready() -> void:
    pos = global_position
    rot = rotation
    apply_textures()

func update_walls():
    # Main walls
    n.visible = wall_up
    e.visible = wall_right
    w.visible = wall_left
    s.visible = wall_down

    # Set wall types for main walls
    n.type = Wall.Type.CENTER
    e.type = Wall.Type.CENTER
    w.type = Wall.Type.CENTER
    s.type = Wall.Type.CENTER

    # Corner walls visibility
    ne.visible = wall_up or wall_right
    se.visible = wall_right or wall_down
    sw.visible = wall_down or wall_left
    nw.visible = wall_left or wall_up

    # Set corner types based on adjacent walls
    if wall_up and wall_right:
        ne.type = Wall.Type.CORNER
    else:
        ne.type = Wall.Type.END

    if wall_right and wall_down:
        se.type = Wall.Type.CORNER
    else:
        se.type = Wall.Type.END

    if wall_down and wall_left:
        sw.type = Wall.Type.CORNER
    else:
        sw.type = Wall.Type.END

    if wall_left and wall_up:
        nw.type = Wall.Type.CORNER
    else:
        nw.type = Wall.Type.END


    # rotate those corner tiles to face the walls which are not corner
    if ne.type == Wall.Type.END and wall_right:
        ne.face = Wall.Face.UP
        ne.offset = Vector2(4, 4)
    else:
        ne.face = Wall.Face.RIGHT
        ne.offset = Vector2.ZERO

    if se.type == Wall.Type.END and wall_down:
        se.face = Wall.Face.RIGHT
        se.offset = Vector2(-4, 4)
    else:
        se.face = Wall.Face.DOWN
        se.offset = Vector2.ZERO

    if sw.type == Wall.Type.END and wall_left:
        sw.face = Wall.Face.DOWN
        sw.offset = Vector2(-4, -4)
    else:
        sw.face = Wall.Face.LEFT
        sw.offset = Vector2.ZERO

    if nw.type == Wall.Type.END and wall_up:
        nw.face = Wall.Face.LEFT
        nw.offset = Vector2(4, -4)
    else:
        nw.face = Wall.Face.UP
        nw.offset = Vector2.ZERO


func apply_textures():
    if textures.is_empty():
        return

    n.textures = textures
    e.textures = textures
    w.textures = textures
    s.textures = textures
    ne.textures = textures
    se.textures = textures
    nw.textures = textures
    sw.textures = textures
