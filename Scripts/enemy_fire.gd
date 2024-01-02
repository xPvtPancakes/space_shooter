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

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
