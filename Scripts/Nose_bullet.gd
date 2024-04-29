extends Area2D

var speed = 550
signal health_changed

func _physics_process(delta):
	position += transform.y * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()



func _on_area_entered(area):
	if area.name == "player_diameter":
		PlayerVariables.emit_signal("player_damage", -1)
		queue_free()
	if area.name == "Railgun":
		queue_free()
	if area.name == "Shield":
		queue_free()
