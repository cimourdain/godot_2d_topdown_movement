tool
extends TopDownMovementOwner


class_name Patrol
var patrol_points = [
    {
        "patrol_point": Vector2(150, 150), 
        "watch_points": [
            Vector2(160, 67),
            Vector2(63, 150),
        ]
    },
    {
        "patrol_point": Vector2(300, 300), 
        "watch_points": [
            Vector2(450, 300),
            Vector2(300, 450),
        ]
    },
]
var current_target_point_id = 0
var current_watchpoint_id = 0

func _update_patrol_point() -> void:
    var patrol_points_count = patrol_points.size()
    current_target_point_id = (current_target_point_id + 1) % patrol_points_count
    
func _update_watch_point() -> void:
    current_watchpoint_id += 1

func current_patrol_point() -> Vector2:
    return patrol_points[current_target_point_id]["patrol_point"]
    
func current_watch_point() -> Vector2:
    return patrol_points[current_target_point_id]["watch_points"][current_watchpoint_id]

func _process(delta: float) -> void:
    if not is_arrived(current_patrol_point()):
        move_to(current_patrol_point())
        return
        
    if is_watching(current_watch_point()):
        _update_watch_point()
            
    if current_watchpoint_id < patrol_points[current_target_point_id]["watch_points"].size():
        rotate_smoothly_to_watch(current_watch_point())
    else:
        _update_patrol_point()
        current_watchpoint_id = 0
        
    
    
