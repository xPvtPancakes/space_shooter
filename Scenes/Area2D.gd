extends Area2D


var speed = 750

func _physics_process(delta):
	position += transform.y * speed * delta * -1


func _on_body_entered(body):
	if body.name == "green_enemy":
		body.queue_free()
		queue_free()
		PlayerVariables.emit_signal("score_up", 20)
