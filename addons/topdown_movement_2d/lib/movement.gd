tool
extends Resource

enum DIRECTION {FORWARD, BACKWARD}
enum TYPE {DIRECTIONAL, ROTATION}
class_name TopDownMovement

var target_position: Vector2
var type = TYPE.DIRECTIONAL
var direction = DIRECTION.FORWARD
var speed: float
var friction: float
var acceleration: float
