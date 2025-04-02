@tool
extends Node2D
class_name Wall
enum Type {CENTER, END, NO_END, CORNER}
enum Face {RIGHT, LEFT, UP, DOWN}

@onready var center: StaticBody2D = $Center
@onready var end: StaticBody2D = $End
@onready var no_end: StaticBody2D = $NoEnd
@onready var corner: StaticBody2D = $Corner
@onready var orginal_pos: Vector2 = global_position
@onready var orginal_rot: float = rotation

@export var type: Type = Type.CENTER:
    set(value):
        type = value
        match value:
            Type.CENTER:
                $Center.visible = true
                $End.visible = false
                $NoEnd.visible = false
                $Corner.visible = false
                update_wall_textures()
            Type.END:
                $End.visible = true
                $Center.visible = false
                $NoEnd.visible = false
                $Corner.visible = false
                update_wall_textures()
            Type.NO_END:
                $NoEnd.visible = true
                $Center.visible = false
                $End.visible = false
                $Corner.visible = false
                update_wall_textures()
            Type.CORNER:
                $Corner.visible = true
                $Center.visible = false
                $End.visible = false
                $NoEnd.visible = false
                update_wall_textures()

@export var face: Face = Face.RIGHT:
    set(value):
        face = value
        match value:
            Face.RIGHT:
                rotation = 0
            Face.LEFT:
                rotation = PI
            Face.UP:
                rotation = -PI/2
            Face.DOWN:
                rotation = PI/2

@export var offset: Vector2 = Vector2.ZERO:
    set(value):
        offset = value
        global_position = orginal_pos + offset

@export var show_collision_shapes: bool = false:
    set(value):
        show_collision_shapes = value
        center.get_node("CollisionPolygon2D").visible = value
        end.get_node("CollisionPolygon2D").visible = value
        no_end.get_node("CollisionPolygon2D").visible = value
        corner.get_node("CollisionPolygon2D").visible = value

@export_group("Textures")

@export var textures: Dictionary[Type, Texture2D] = {
    Type.CENTER: null,
    Type.END: null,
    Type.NO_END: null,
    Type.CORNER: null
}:
    set(value):
        textures = value
        update_wall_textures()


func update_wall_textures():
    match type:
        Type.CENTER:
            if textures[Type.CENTER] == null:
                center.get_node("Sprite2D").texture = null
                return
            center.get_node("Sprite2D").texture = textures[Type.CENTER]
        Type.END:
            if textures[Type.END] == null:
                end.get_node("Sprite2D").texture = null
                return
            end.get_node("Sprite2D").texture = textures[Type.END]
        Type.NO_END:
            if textures[Type.NO_END] == null:
                no_end.get_node("Sprite2D").texture = null
                return
            no_end.get_node("Sprite2D").texture = textures[Type.NO_END]
        Type.CORNER:
            if textures[Type.CORNER] == null:
                corner.get_node("Sprite2D").texture = null
                return
            corner.get_node("Sprite2D").texture = textures[Type.CORNER]

