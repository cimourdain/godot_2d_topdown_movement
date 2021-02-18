tool
extends Node2D

class_name TopDownMovementManager

# current move owner
var movement_owner: TopDownMovementOwner
# list of move owner managed by this instance
var movements_owners: Array # Array[TopDownMovementOwner]
var previous_move: TopDownMovement
var velocity = Vector2.ZERO

onready var character: KinematicBody2D = get_parent()
onready var nav2d = get_tree().get_current_scene().get_node_or_null("Navigation2D")

func _ready() -> void:
    """
    Initialize Movement manager by adding its owners and setting default.
    """
    for movement_type in get_children():
        print("register " + movement_type.name)
        movements_owners.append(movement_type)

    movement_owner = _get_default_move_owner()

func _get_active_movement_owner() -> TopDownMovementOwner:
    for movement_type in movements_owners:
        if movement_type.active == true:
            return movement_type

    return _get_default_move_owner()

func _get_default_move_owner() -> TopDownMovementOwner:
    if movements_owners.size() < 1:
        set_process(false)
        return null

    var default_move_owner = movements_owners[-1]
    if not default_move_owner.active:
        default_move_owner.active = true
    return default_move_owner

###################
# DIRECTIONAL MOVEMENT
###################
func _build_move_path(target_position: Vector2) -> PoolVector2Array:
    if not nav2d:
        return PoolVector2Array([target_position])
        
    var path = nav2d.get_simple_path(
        character.global_position, 
        target_position, 
        false
    )
    return path
    
func _perform_directional_move(move: TopDownMovement, delta: float) -> void:
    var path = _build_move_path(move.target_position)
#	var line = get_tree().get_current_scene().get_node_or_null("Line2D")
#	line.points = path
    if not path:
        return
        
    var max_distance = move.speed * delta

    var i = 0
    var distance_to_next_path_point: float
    var next_path_point: Vector2
    while i < path.size() and max_distance > distance_to_next_path_point:
        distance_to_next_path_point = character.global_position.distance_to(path[i])
        next_path_point = path[i]
        i += 1
    
    if next_path_point == character.global_position:
        character.global_position = move.target_position
        assert (is_arrived(move.target_position))
        return
    elif distance_to_next_path_point < 10:
        character.global_position = next_path_point
        return

    character.look_at(next_path_point)
    velocity = character.transform.x * move.speed * move.direction
    velocity = lerp(
        velocity, 
        next_path_point.normalized() * move.speed, 
        delta
    )
    velocity = character.move_and_slide(velocity)	
        

func is_arrived(target_point: Vector2) -> bool:
    if not character:
        return false
        
    var distance_to_target : = character.global_position.distance_to(target_point)
    if distance_to_target > 1:
        # print(str(distance_to_target))
        return false
    return true
    
###################
# ROTATION
###################
func get_rotation_angle_and_direction(from: float, to: float) -> Dictionary:
    var from_norm = fmod(from, TAU) + 2 * PI
    var to_norm = fmod(to, TAU) + 2 * PI
    
    var biggest = max(from_norm, to_norm)
    var smallest = min(from_norm, to_norm)
    var inside_gap = biggest - smallest
    var outside_gap = (2 * PI + smallest) - biggest
    
    var direction: int
    if inside_gap < outside_gap:
        direction = 1 if from < to else -1
        return {"gap": inside_gap, "direction": direction}
    direction = 1 if from > to else -1
    return {"gap": outside_gap, "direction": direction}
    
func _perform_rotation(move: TopDownMovement, delta: float) -> void:
    var target_character_rotation = get_character_target_rotation_to_face(
        move.target_position
    )
    var rotation_order = get_rotation_angle_and_direction(
        character.rotation, 
        target_character_rotation
    )
    
    var rotation_step = (PI / 1000) * move.speed
    character.rotation += min(rotation_order["gap"], rotation_step) * rotation_order["direction"]

func get_character_target_rotation_to_face(target_point: Vector2) -> float:
    return target_point.angle_to_point(character.global_position)

func is_watching(target_point: Vector2) -> bool:
    var rotation_order = get_rotation_angle_and_direction(
        character.rotation, 
        get_character_target_rotation_to_face(target_point)
    )
    var is_facing = abs(rotation_order["gap"]) < 0.01
    return is_facing

###################
# PROCESS
###################
func _process(delta: float):
    movement_owner = _get_active_movement_owner()
    if not movement_owner:
        return

    var next_move = movement_owner.get_next_move()
    if next_move:
        if next_move.type == TopDownMovement.TYPE.DIRECTIONAL:
            _perform_directional_move(next_move, delta)
        elif next_move.type == TopDownMovement.TYPE.ROTATION:
            _perform_rotation(next_move, delta)
    previous_move = next_move
