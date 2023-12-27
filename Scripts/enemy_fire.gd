extends Area2D

var speed = 750
signal health_changed

func _physics_process(delta):
	position += transform.y * speed * delta

#func _ready():


func _on_body_entered(body):
	if body.name == "blue_ship":
		PlayerVariables.emit_signal("player_damage", -1)
		queue_free()


