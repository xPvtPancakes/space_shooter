extends Area2D


var speed = 750

func _physics_process(delta):
	position += transform.y * speed * delta * -1


func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.queue_free()
		$Explosion_SE.play()
		
		PlayerVariables.emit_signal("score_up", 20)
		$Sheet.set_deferred("visible", false)
		$CollisionShape2D.set_deferred("disabled", true)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_explosion_se_finished():
	queue_free()
