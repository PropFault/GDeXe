extends RigidBody3D
@onready var body = $arcade/Cube
@export var base_screen_material : StandardMaterial3D
@export var scene_to_display : PackedScene
var scene : Viewport
var in_use = false
# Called when the node enters the scene tree for the first time.
func _setup_tex():
	base_screen_material.albedo_texture = scene.get_texture()
	body.set_surface_override_material(1,  base_screen_material)

func _ready() -> void:
	scene = scene_to_display.instantiate()
	get_tree().root.add_child.call_deferred(scene)
	call_deferred("_setup_tex")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_interact():
	in_use = true
	PlayerInput.aquire_lock(self)
