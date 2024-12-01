extends RigidBody2D
@export var hp = 100.0
@export var has_shield = true
@export var max_shield = 100.0
@export var cur_shield = 100.0
@export var shield_recharge_rate = 50.0
@export var shield_recharge_timeout = 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
