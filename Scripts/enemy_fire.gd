extends Area2D

var speed = 750
signal health_changed
func _physics_process(delta):
	position += transform.y * speed * delta


func _on_body_entered(body):
	pass
	#if body.name == "blue_ship":
		#print("check2")
	#queue_free()
		
