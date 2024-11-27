extends RigidBody3D
class_name GrabableRigidBody3D
var target_point: Node3D = null
var max_grab_distance_sqr = 5.0
var max_grab_force = 200000
var grab_speed = 1.0
var grabbed_rot = null
signal on_released(this)
func on_grab(_target_point, _max_grab_force, _max_grab_distance_sqr, _grab_speed):
	self.target_point = _target_point
	self.max_grab_distance_sqr = _max_grab_distance_sqr
	self.max_grab_force = _max_grab_force
	self.grab_speed = _grab_speed
	self.sleeping = false
	self.grabbed_rot = target_point.rotation
	self.collision_layer = 0b00000000_00000000_00000000_00000010
	

func on_release():
	self.target_point = null
	self.collision_layer = 0b00000000_00000000_00000000_00000001
	on_released.emit(self)



func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if target_point != null:
		var delta = self.global_position - target_point.global_position
		if delta.length_squared() > max_grab_distance_sqr:
			on_release()
		var delta_force = (delta / grab_speed) * self.mass
		delta_force = delta_force.normalized() * clamp(delta_force.length(), 0.0, max_grab_force)
		state.linear_velocity = -(delta_force / self.mass)
		
