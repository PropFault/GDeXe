extends RayCast3D
@export var input : PlayerInput
@export var max_force = 100
@export var attract_time = 0.1
@export var max_dist_sqr = 10.0
@export var throw_impulse = 50
@onready var float_target = $FloatTarget
var grabbed_objects: Array[GrabableRigidBody3D] = []
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	input.update()
	if input.interactButton:
		if self.is_colliding():
			var collider = self.get_collider()
			
			if grabbed_objects.has(collider):
				collider.on_release()
				grabbed_objects.erase(collider)
			elif collider.has_method("on_grab"):
				collider.on_grab(float_target, max_force, max_dist_sqr, attract_time)
				grabbed_objects.push_back(collider)
		else:
			for obj in grabbed_objects:
				obj.on_release()
			grabbed_objects.clear()

	if input.primary_just_pressed:
		for obj in grabbed_objects:
			obj.on_release()
			obj.apply_impulse(-self.global_transform.basis.y * throw_impulse)
		grabbed_objects.clear()
