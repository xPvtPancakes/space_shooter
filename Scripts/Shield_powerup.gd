extends Area2D

var speed = 300

func _process(delta):
	position += transform.y * speed * delta


func _on_area_entered(area):
	if area.is_in_group("player") or area.is_in_group("player_fire"):
		powerup()
		
func powerup():
	PlayerVariables.emit_signal("shield", 3)
	PlayerVariables.emit_signal("score_up", 50)
	queue_free()
