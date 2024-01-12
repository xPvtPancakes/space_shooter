extends CharacterBody2D

@export var enemy_fire : PackedScene
#var start_position = Vector2.ZERO
var speed = 0
@onready var screensize = get_viewport_rect().size

func start(_pos):
	speed = 200
	#position = Vector2(pos.x, -pos.y)
	#start_position = pos
	await get_tree().create_timer(randf_range(0.25, 0.55)).timeout
	#var tween = create_tween().set_trans(Tween.TRANS_BACK)
	#tween.tween_property(self, "position:y", start_position.y, 1.4)
	#await tween.finished
	$MoveTimer.wait_time = randf_range(5, 20)
	$MoveTimer.start()
	$ShootTimer.wait_time = randf_range(1, 3)
	$ShootTimer.start()


	
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
	print("enemy queue_free")




func shooting():
	$Shoot_SE.play()
	var b = enemy_fire.instantiate()
	get_tree().root.add_child(b)
	b.transform = $Guns.global_transform



func _on_shoot_timer_timeout():
	shooting()




func _on_area_2d_body_entered(body):
	if body.name == "blue_ship":
		PlayerVariables.emit_signal("player_damage", -1)
		$Explosion_SE.play()
		queue_free()
