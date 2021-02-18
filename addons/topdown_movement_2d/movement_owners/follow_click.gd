tool
extends TopDownMovementOwner

class_name FollowClick

var last_click_position: Vector2
# Pre-requisite: create a `ui_mouse_left` input in events or update this var
export var click_event_name : = "ui_mouse_left"

func _input(event):
    if event.is_action_pressed(click_event_name):
        print("click detected")
        last_click_position = get_global_mouse_position()
        active = true

func _process(event):
    if not movement_manager:
        return
        
    if movement_manager.is_arrived(last_click_position):
        active = false
        return

    move_to(last_click_position)
