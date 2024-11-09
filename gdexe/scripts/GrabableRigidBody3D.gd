extends RigidBody3D
class_name GrabableRigidBody3D
var target_point: Node3D = null
var max_grab_distance_sqr = 5.0
var max_grab_force = 200000
var grab_speed = 1.0
func on_grab(target_point, max_grab_force, max_grab_distance_sqr, grab_speed):
	self.target_point = target_point
	self.max_grab_distance_sqr = max_grab_distance_sqr
	self.max_grab_force = max_grab_force
	self.grab_speed = grab_speed
	self.sleeping = false

func on_release():
	self.target_point = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if target_point != null:
		var delta = self.global_position - target_point.global_position
		if delta.length_squared() > max_grab_distance_sqr:
			on_release()
		var delta_force = (delta / grab_speed) * self.mass
		delta_force = delta_force.normalized() * clamp(delta_force.length(), 0.0, max_grab_force)
		state.linear_velocity = -(delta_force / self.mass)
