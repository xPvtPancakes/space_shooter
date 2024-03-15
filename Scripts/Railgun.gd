extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("Start")
	$Rail_se.play()
	expand()


func expand():
	for i in 5:
		$AnimatedSprite2D.scale += Vector2(0.3,0.3)
		$Start_shape.scale += Vector2(0.3,0.3)
		await(get_tree().create_timer(0.01).timeout)
	await(get_tree().create_timer(0.5).timeout)
	$AnimatedSprite2D.play("Laser")
	$AnimatedSprite2D.scale = Vector2(2.823, 10.1)
	$AnimatedSprite2D.position = Vector2(0, -318)
	$Full_shot.set_deferred("disabled", false)
	#for i in 10:
		#$AnimatedSprite2D.scale += Vector2(0,0.5)
		#await(get_tree().create_timer(0.01).timeout)
	#for i in 10:
		#$AnimatedSprite2D.scale += Vector2(0.3,0)
		#await(get_tree().create_timer(0.02).timeout)
