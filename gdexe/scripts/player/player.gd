extends RigidBody3D

@export var walk_speed = 3.0
@export var walk_accel_factor = 5.0
@export var run_speed = 8.0
@export var run_accel_factor = 10.0
@export var input_enabled = true
@export var is_running = false
@export var is_running_default_state = true
@onready var _downcast = $DownCast
@onready var jump_impulse = 20000

var can_jump = true
@onready var _input = $PlayerInput
@onready var _forward = $ForwardRef
func is_on_ground():
	return _downcast.is_colliding()

func _process(_delta: float) -> void:
	if(input_enabled):
		_input.update()
		if(_input.movementModeButton):
			is_running = !is_running_default_state
		else:
			is_running = is_running_default_state
		if(is_on_ground()):
			var movement_speed = 0.0
			var movement_accel_factor = 0.0
			if(is_running):
				movement_speed = run_speed
				movement_accel_factor = run_accel_factor
			else:
				movement_speed = walk_speed
				movement_accel_factor = walk_accel_factor
			var mvmtDir = _forward.transform.basis * Vector3(_input.movementInput.x,0.0 ,  _input.movementInput.y)
			var vDelta = (mvmtDir * movement_speed - self.linear_velocity)
			vDelta = Vector3(vDelta.x, 0.0 ,vDelta.z)
			if(vDelta.length() < 0.0):
				vDelta = Vector3.ZERO
			var moveForce = movement_accel_factor * vDelta
			if _input.jumpButton and can_jump:
				moveForce.y = jump_impulse / self.mass
				can_jump = false
			self.apply_force(moveForce * self.mass ); #mass independent
		else:
			can_jump = true
