extends Node2D

var speed = 00


func _physics_process(delta):
	position += transform.y * speed * delta


func _on_ts_area_body_entered(body):
	if body.name == "blue_ship":
		powerup()



func powerup():
	PlayerVariables.emit_signal("triple_shot", true)
	queue_free()


func _on_ts_area_area_entered(area):
	if area.name == "blue_shot":
		powerup()
