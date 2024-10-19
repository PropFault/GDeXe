extends Node
class_name PlayerInput

var _owner: InputLock = null

func aquire_lock() -> InputLock:
	if(_owner == null):
		_owner = InputLock.new(self)
		return _owner
	return null
