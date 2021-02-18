tool
extends Node2D


class_name TopDownMovementOwner

export var active : = false
export var speed: float = 200.0
export var direction: int = 1  # 1 = forward, -1 = backward
export var friction: float = 0.01
export var acceleration: float = 0.1
export var rotation_speed: float = 10

var next_move: TopDownMovement
onready var movement_manager: Node2D = get_parent()
onready var character: KinematicBody2D = get_parent().get_parent()

        
func _build_next_move(
        _target_position: Vector2 = character.global_position, 
        _direction: int = direction, 
        _speed: float = speed, 
        _friction: float = friction, 
        _acceleration: float = acceleration
    ) -> TopDownMovement:

    var new_next_move = TopDownMovement.new()
    new_next_move.type = TopDownMovement.TYPE.DIRECTIONAL
    new_next_move.target_position = _target_position
    new_next_move.direction = _direction
    new_next_move.speed = _speed
    new_next_move.friction = _friction
    new_next_move.acceleration = _acceleration

    return new_next_move
    
func _build_rotation(
        _target_position: Vector2,
        _rotation_speed: float = rotation_speed
    ) -> TopDownMovement:
    
    var next_rotation = TopDownMovement.new()
    next_rotation.target_position = _target_position
    next_rotation.type = TopDownMovement.TYPE.ROTATION
    next_rotation.speed = rotation_speed
    
    return next_rotation
    
func get_next_move() -> TopDownMovement:
    return next_move

###################
# MOVEMENTS
###################
func move_to(_position: Vector2) -> void:
    next_move = _build_next_move(_position)
    
func move_backwards_to(_position: Vector2) -> void:
    next_move = _build_next_move(_position, -1)
    
func rotate_smoothly_to_watch(_position: Vector2) -> void:
    next_move = _build_rotation(_position)

###################
# CHECKS
###################
func is_arrived(_position: Vector2) -> bool:
    # Check if character is arrived to input position.
    return movement_manager.is_arrived(_position)

func is_watching(_position: Vector2) -> bool:
    # Check if character is watching in direction of the input position
    return movement_manager.is_watching(_position)
