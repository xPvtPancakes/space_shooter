extends CharacterBody2D

@export var enemy_fire : PackedScene
var health = 11
var fire_mode = 1

func shooting():
	if fire_mode == 1:
		var b = enemy_fire.instantiate()
		get_tree().root.add_child(b)
		b.transform = $Gun1.global_transform
		
	if fire_mode == 2:
		$Gun1.transform.position(-93, 50)
		var b = enemy_fire.instantiate()
		get_tree().root.add_child(b)
		b.transform = $Gun1.global_transform
		var b2 = enemy_fire.instantiate()
		get_tree().root.add_child(b2)
		b2.transform = $Gun2.global_transform
		var b3 = enemy_fire.instantiate()
		get_tree().root.add_child(b3)
		b3.transform = $Gun3.global_transform

func _on_shoot_timer_timeout():
	shooting()

func health_loss():
	health -= 1
	if health <= 0:
		queue_free()
	$Invul_timer.start()
	print(health)
	
	if health == 10:
		$Shoot_Timer.paused = true
		fire_mode = 2
		Second_Phase()

##Getting hit with shots from the player
func _on_area_2d_area_entered(area):
	if area.is_in_group("player") and $Invul_timer.time_left == 0:
		health_loss()

	#if area.is_in_group("player") and $Invul_timer.time_left > 0:
		#print("invulnerable")
		#print($Invul_timer.time_left)


func Second_Phase():
	for i in 18:
		$Sprite2D.rotate(PI/18)
		await(get_tree().create_timer(0.05).timeout)
	await(get_tree().create_timer(3).timeout)
	$Shoot_Timer.paused = false
