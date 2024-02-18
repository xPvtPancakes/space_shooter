extends CharacterBody2D

@export var enemy_fire : PackedScene
#var start_position = Vector2.ZERO
var speed = 200
var hp = 1
var score = 20

@onready var screensize = get_viewport_rect().size

var type_from_main


func start(_pos):
	#speed = 200

	await get_tree().create_timer(randf_range(0.25, 0.55)).timeout

	$MoveTimer.wait_time = randf_range(5, 20)
	$MoveTimer.start()
	$ShootTimer.wait_time = randf_range(1, 3)
	$ShootTimer.start()

func set_type(type_value):
	type_from_main= floor(type_value)
	if type_from_main < 1:
		$EnemyType.play("green")
	if type_from_main >= 1 && type_from_main <= 2:
		$EnemyType.play("orange")
		hp = 2
		score = 50
		speed = 300
	if type_from_main >= 2:
		$EnemyType.play("blue")
		hp = 3
		score = 100
		speed = 400

	
func _process(delta):


	position.x += speed * delta
	if position.x >= screensize.x &&  speed * delta > 0:
		position.y += 50
		speed = speed * -1.2
		position.x += speed * delta
	if position.x <= 0:
		position.y += 50
		speed = speed * -1.2
		position.x += speed * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func shooting():
	$Shoot_SE.play()
	print(type_from_main)
	if type_from_main < 1 || type_from_main == 2:
		var b = enemy_fire.instantiate()
		get_tree().root.add_child(b)
		b.transform = $Guns.global_transform
	if type_from_main == 1 || type_from_main == 2:
		var b2 = enemy_fire.instantiate()
		get_tree().root.add_child(b2)
		b2.transform = $Guns2.global_transform
		var b3 = enemy_fire.instantiate()
		get_tree().root.add_child(b3)
		b3.transform = $Guns3.global_transform



func _on_shoot_timer_timeout():
	shooting()


func dead():
	$EnemyType.scale = Vector2(0.134, 0.134)
	$EnemyType.play("dead")
	$ShootTimer.stop()
	$Area2D.set_deferred("monitorable", false)
	$Area2D.set_deferred("monitoring", false)
	$CollisionPolygon2D2.set_deferred("disabled", true)
	$Area2D.set_deferred("monitoring", false)
	$Explosion_SE.play()

func _on_explosion_se_finished():
	queue_free()


func _on_area_2d_area_entered(area):
	if area.is_in_group("player_fire"):
		hp -= 1
		if hp <= 0:
			PlayerVariables.emit_signal("score_up", score)
			dead()
	if area.is_in_group("player"):
		PlayerVariables.emit_signal("player_damage", -1)
		dead()
	if area.is_in_group("railgun"):
		PlayerVariables.emit_signal("score_up", score)
		dead()
	if area.is_in_group("comet"):
		dead()


func _on_enemy_type_animation_finished():
	$EnemyType.set_deferred("visible", false)
