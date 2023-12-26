extends RigidBody2D
#Rigidbody makes the whole ship go flying off in a weird direction
var speed = 750

func _physics_process(delta):
	position += transform.x * speed * delta
