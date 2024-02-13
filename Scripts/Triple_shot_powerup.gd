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
	queue_free()


func _on_ts_area_area_entered(area):
	print(area.name)
	if area.is_in_group("player"):
		powerup()
