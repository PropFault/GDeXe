extends Node
var movementInput = Vector2(0.0,0.0)
var lookInput = Vector2(0.0,0.0)
var _mouseLook = Vector2(0.0, 0.0)
var movementModeButton = false
var jumpButton = false
var interactButton = false
var _interactButtonJustPressed = false
var mouseSensitivity = 1.0
var primary = false
var primary_just_pressed = false
var _primary_just_pressed = false
var rotateButton = false
@onready var curPos = get_viewport().get_mouse_position()
@onready var _lastPos = get_viewport().get_mouse_position()

var _lock = null

func get_shared():
	if _lock == null:
		return _get_dict()
	return null

func aquire_lock(caller):
	if _lock != null:
		return false
	else:
		_lock = caller
		return true

func get_exclusive(caller):
	if _lock == null:
		aquire_lock(caller)
	if _lock == caller:
		return _get_dict()
	return null

func release_lock(caller):
	if _lock == caller:
		_lock = null
		return true
	return false

func _get_dict():
	lookInput = Vector2.ZERO
	return {
		"movementInput": Input.get_vector("right","left","down","up"),
		"movementModeButton": Input.is_action_pressed("mvntMode"),
		"jumpButton": Input.is_action_pressed("jump"),
		"lookInput": Input.get_vector("look_right", "look_left", "look_down", "look_up") + _mouseLook,
		"interactButton": _interactButtonJustPressed,
		"primary_just_pressed": _primary_just_pressed,
		"primary": Input.is_action_pressed("primary"),
		"rotateButton": Input.is_action_pressed("rotate")
	}

func _process(_delta: float) -> void:
	_mouseLook = (curPos - _lastPos) * mouseSensitivity / 10.0
	_mouseLook.x = -_mouseLook.x
	_lastPos = curPos
	_interactButtonJustPressed = Input.is_action_just_pressed("interact")
	_primary_just_pressed = Input.is_action_just_pressed("primary")
	
func _input(event: InputEvent) -> void:
	if(event is InputEventMouseMotion):
		curPos = curPos + event.relative
