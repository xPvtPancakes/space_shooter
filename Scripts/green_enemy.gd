extends CharacterBody2D

@export var enemy_fire : PackedScene
#var start_position = Vector2.ZERO
var speed = 0
var hp = 1
var score = 20
@onready var screensize = get_viewport_rect().size

var type_from_main


func start(_pos):
	speed = 200

	await get_tree().create_timer(randf_range(0.25, 0.55)).timeout

	$MoveTimer.wait_time = randf_range(5, 20)
	$MoveTimer.start()
	$ShootTimer.wait_time = randf_range(1, 3)
	$ShootTimer.start()

func set_type(type_value):
	type_from_main=type_value
	if type_from_main >= 1 && type_from_main <= 2:
		$EnemyType.play("orange")
		hp = 2
		score = 50
	if type_from_main >= 2:
		$EnemyType.play("blue")
		hp = 3
		score = 100

	
func _process(delta):


	position.x += speed * delta
	if position.x >= screensize.x &&  speed * delta > 0:
		position.y += 50
		speed = speed * -1.02
		position.x += speed * delta
	if position.x <= 0:
		position.y += 50
		speed = speed * -1.2
		position.x += speed * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func shooting():
	$Shoot_SE.play()
	var b = enemy_fire.instantiate()
	get_tree().root.add_child(b)
	b.transform = $Guns.global_transform



func _on_shoot_timer_timeout():
	shooting()



func _on_area_2d_body_entered(body):
	pass
	#if body.name == "blue_ship":
		#PlayerVariables.emit_signal("player_damage", -1)
		#speed=0
		#dead()

	
			


func dead():
	$EnemyType.set_deferred("visible", false)
	$Area2D.set_deferred("monitorable", false)
	$Area2D.set_deferred("monitoring", false)
	$ShootTimer.stop()
	$CollisionPolygon2D2.set_deferred("disabled", true)
	$Area2D.set_deferred("monitoring", false)
	$Explosion_SE.play()

func _on_explosion_se_finished():
	queue_free()


#func _on_area_2d_area_entered(area):
	#if area.is_in_group("player_fire"):
#
		#hp -= 1
		#if hp == 0:
			#PlayerVariables.emit_signal("score_up", score)
			#dead()
			#$Explosion_SE.play()


func _on_area_2d_area_entered(area):
	if area.is_in_group("player_fire"):
		hp -= 1
		print(hp)
		if hp == 0:
			PlayerVariables.emit_signal("score_up", score)
			dead()
	if area.is_in_group("player"):
		PlayerVariables.emit_signal("player_damage", -1)
		speed=0
		dead()
