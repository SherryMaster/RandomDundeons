extends CharacterBody2D

@export var speed: float = 300.0
@export var rotation_speed: float = 10.0  # Adjust this to control rotation smoothness

func _ready() -> void:
    pass

func _physics_process(delta: float) -> void:
    # Get input direction
    var direction = Vector2.ZERO
    direction.x = Input.get_axis("left", "right")
    direction.y = Input.get_axis("up", "down")
    
    # Normalize the direction to prevent faster diagonal movement
    direction = direction.normalized()
    
    # Set velocity
    velocity = direction * speed
    
    # Rotate towards movement direction
    if direction != Vector2.ZERO:
        # Calculate the target rotation
        var target_rotation = direction.angle()
        # Smoothly rotate towards the target rotation
        rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)
    
    # Move the character
    move_and_slide()

