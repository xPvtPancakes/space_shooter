extends Area2D


var speed = 750

func _physics_process(delta):
	position += transform.y * speed * delta * -1


func _on_body_entered(body):
	if body.is_in_group("enemy"):
		$Explosion_SE.play()
		speed=0
		body.queue_free()
		PlayerVariables.emit_signal("score_up", 20)
		$BlueBullet.set_deferred("visible", false)
		$CollisionShape2D.set_deferred("disabled", true)
		$Explosion_Sprite.play("default")
		$Explosion_Sprite.set_deferred("visible", true)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_explosion_se_finished():
	queue_free()



func _on_explosion_sprite_animation_finished():
	$Explosion_Sprite.set_deferred("visible", false)
