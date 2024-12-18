extends RayCast3D
@export var player_body: RigidBody3D
@export var max_force = 100
@export var attract_time = 0.1
@export var max_dist_sqr = 10.0
@export var throw_impulse = 10
@onready var float_target: Area3D = $FloatTarget
@onready var float_target_col_shape: SphereShape3D = $FloatTarget/CollisionShape3D.shape
@onready var float_target_original_pos = float_target.transform.origin
@export var float_target_rad_margin_fact = 0.5
var float_target_pullback = 0.0
var grabbed_objects = []
@onready var dir_tester: Area3D = $"FloatTarget/DirTester"
func _physics_process(_delta: float) -> void:
	var contains = false
	for body in float_target.get_overlapping_bodies():
		if not grabbed_objects.has(body) and body != player_body :
			contains = true
	if contains:
		#TODO: Pull into correct direction
		if not dir_tester.has_overlapping_bodies():
			float_target_pullback += 2.0 * _delta
	elif abs(float_target_pullback) > 0.0:
		float_target_pullback -= sign(float_target_pullback) * 2.0 * _delta
	
	float_target.transform.origin.y = float_target_original_pos.y + float_target_pullback
	
	var aabb = AABB()
	for body in grabbed_objects:
		var shape_owners = body.get_shape_owners()
		for shape_owner in shape_owners:
			var shapeCount = body.shape_owner_get_shape_count(shape_owner)
			for i in range(shapeCount):
				var shape = body.shape_owner_get_shape(shape_owner, i)
				var shape_aabb = shape.get_debug_mesh().get_aabb()
				shape_aabb = shape_aabb * body.transform
				shape_aabb.position = float_target.global_position - body.global_position
				aabb = aabb.merge(shape_aabb)
	var rad =  max(0.1, aabb.get_longest_axis_size()/2.0) * float_target_rad_margin_fact
	float_target_col_shape.radius = rad
	dir_tester.position.y = rad * 2.0
	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_released(obj):
	grabbed_objects.erase(obj)
func _process(_delta: float) -> void:
	var input = PlayerInput.get_shared()
	if input != null:
		if input.rotateButton:
			float_target.transform = float_target.transform.rotated_local(Vector3(1.0, 0.0, 0.0), input.lookInput.x * _delta)
			float_target.transform = float_target.transform.rotated_local(Vector3(0.0, 0.0, 1.0), input.lookInput.y * _delta)
		if input.interactButton:
			if self.is_colliding():
				var collider = self.get_collider()
				if collider.has_method("on_interact"):
					collider.on_interact()
				if grabbed_objects.has(collider):
					collider.on_release()
					grabbed_objects.erase(collider)
				elif collider.has_method("on_grab"):
					var grabbable = collider as GrabableRigidBody3D
					collider.on_grab(float_target, max_force, max_dist_sqr, attract_time)
					grabbed_objects.push_back(collider)
					grabbable.on_released.connect(_on_released)
			else:
				for obj in grabbed_objects:
					obj.on_release()
				grabbed_objects.clear()

		if input.primary_just_pressed:
			for obj in grabbed_objects:
				obj.on_release()
				obj.apply_impulse(-self.global_transform.basis.y * throw_impulse)
			grabbed_objects.clear()
