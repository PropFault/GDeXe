extends Camera3D
@onready var body = $"../"
@onready var input : PlayerInput = $"../../PlayerInput"


func _process(delta: float) -> void:
	if(Input.is_key_pressed(KEY_0)):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if(Input.is_key_pressed(KEY_ESCAPE)):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	input.update()
	body.rotate_y(input.lookInput.x * delta)
	self.rotate_x(input.lookInput.y * delta)
