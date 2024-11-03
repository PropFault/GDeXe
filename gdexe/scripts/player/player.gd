extends RigidBody3D

@export var walk_speed = 3.0
@export var walk_accel_factor = 10.0
@export var run_speed = 8.0
@export var run_accel_factor = 20.0
@export var input_enabled = true
@export var is_running = false
@export var is_running_default_state = true
@onready var _downcast = $DownCast
var _input = PlayerInput.new()

func is_on_ground():
	return _downcast.is_colliding()

func _process(delta: float) -> void:
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
			var mvmtDir = Vector3(_input.movementInput.x,0.0 ,  _input.movementInput.y)
			print("mvmtDir * movement_speed ", (mvmtDir * movement_speed), "v: ", self.linear_velocity)
			var vDelta = (mvmtDir * movement_speed - self.linear_velocity).length() #TODO: Fix movement being sluggish when reversing direction.
			#TODO: add graphing stuff 
			if(vDelta < 0.0):
				vDelta = 0.0
			print("vDelta: ", vDelta, " movInp: ", _input.movementInput, " v: ", self.linear_velocity)
			var moveForce = mvmtDir * movement_accel_factor * vDelta
			print(moveForce)
			self.apply_force(moveForce * self.mass); #mass independent
		
