class_name PlayerInput
var movementInput = Vector2(0.0,0.0)
var movementModeButton = false

func update():
	movementInput =Input.get_vector("right","left","down","up")
	movementModeButton = Input.is_action_pressed("mvntMode")
