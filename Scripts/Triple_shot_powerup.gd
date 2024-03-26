extends Node2D

var speed = 300


func _physics_process(delta):
	position += transform.y * speed * delta


#func _on_ts_area_body_entered(body):
	#print(body)
	#if body.name == "blue_ship":
		#powerup()



func powerup():
	PlayerVariables.emit_signal("triple_shot", true)
	PlayerVariables.emit_signal("score_up", 50)
	queue_free()


func _on_ts_area_area_entered(area):
	if area.is_in_group("player") or area.is_in_group("player_fire"):
		powerup()
