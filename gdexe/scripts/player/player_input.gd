extends Node
class_name PlayerInput
var movementInput = Vector2(0.0,0.0)
var lookInput = Vector2(0.0,0.0)
var _mouseLook = Vector2(0.0, 0.0)
var movementModeButton = false
var jumpButton = false
var mouseSensitivity = 1.0
@onready var curPos = get_viewport().get_mouse_position()
@onready var _lastPos = get_viewport().get_mouse_position()

func update():
	movementInput = Input.get_vector("right","left","down","up")
	movementModeButton = Input.is_action_pressed("mvntMode")
	jumpButton = Input.is_action_pressed("jump")
	lookInput = Vector2.ZERO
	lookInput = Input.get_vector("look_right", "look_left", "look_down", "look_up") + _mouseLook

func _process(delta: float) -> void:
	_mouseLook = (curPos - _lastPos) * mouseSensitivity / 10.0
	_mouseLook.x = -_mouseLook.x
	_lastPos = curPos
	
func _input(event: InputEvent) -> void:
	if(event is InputEventMouseMotion):
		curPos = curPos + event.relative
