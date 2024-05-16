extends Area2D

var health = 200

var rng = RandomNumberGenerator.new()


func _ready():
	PlayerVariables.connect("chinthrow", _on_throw_chin)
	PlayerVariables.connect("rail", _on_rail)
	PlayerVariables.connect("shooting", _on_shooting)
	PlayerVariables.connect("headdead", _on_headdead)
	
func _on_throw_chin():
	var moveMe = Vector2(0, 0)
	var initial_bot_pos = $CollisionPolygonBottom.position
	var rand_dir = rng.randf_range(-10, 10)
	print($CollisionPolygonBottom.position)
	for i in 50:
		moveMe = Vector2(rand_dir, 15)
		$Bottom_sprite.rotation += PI/3
		$CollisionPolygonBottom.rotation += PI/3
		$Bottom_sprite.position += moveMe
		$CollisionPolygonBottom.global_position += moveMe
		await(get_tree().create_timer(0.05).timeout)
		
	$Bottom_sprite.rotation = PI/2
	$Bottom_sprite.position = initial_bot_pos + Vector2(100, 0)
	$CollisionPolygonBottom.rotation = 0
	$CollisionPolygonBottom.position = initial_bot_pos + Vector2(100, 0)
	$ReloadSE.play()
	for i in 20:
		$Bottom_sprite.position.x -= 7
		$CollisionPolygonBottom.position.x -= 7
		await(get_tree().create_timer(0.01).timeout)
	for i in 10:
		$Bottom_sprite.position.x += 4
		$CollisionPolygonBottom.position.x += 4
		await(get_tree().create_timer(0.01).timeout)
	await(get_tree().create_timer(3).timeout)
	
	PlayerVariables.emit_signal("chinthrowfinished")
	
func _on_rail():
	var MoveVec = 30
	for i in 18:
		$Bottom_sprite.position.x -= MoveVec
		$CollisionPolygonBottom.position.x -= MoveVec
		
		await(get_tree().create_timer(0.05).timeout)
		
	await(get_tree().create_timer(2).timeout)
	for i in 18:
		MoveVec = 30
		$Bottom_sprite.position.x += MoveVec
		$CollisionPolygonBottom.position.x += MoveVec
			
		await(get_tree().create_timer(0.025).timeout)
	
func _on_shooting():
	for i in 18:
		$Bottom_sprite.rotation -= PI/36
		$Bottom_sprite.position += Vector2(12, 12)
		$CollisionPolygonBottom.rotation -= PI/36
		$CollisionPolygonBottom.position += Vector2(12,12)
		await(get_tree().create_timer(0.01).timeout)
	
	await(get_tree().create_timer(1.1).timeout)
	
	for i in 18:
		$Bottom_sprite.rotation += PI/36
		$Bottom_sprite.position -= Vector2(12, 12)
		$CollisionPolygonBottom.rotation += PI/36
		$CollisionPolygonBottom.position -= Vector2(12,12)
		await(get_tree().create_timer(0.01).timeout)

func take_damage():
	health -= 1
	if health <= 0:
		PlayerVariables.emit_signal("score_up", 300)
		$Bottom_sprite.scale = Vector2(1, 1)
		$Bottom_sprite.play("explosion")
		$Explosion.play()


func _on_headdead():
	health = 0
	take_damage()

func _on_area_entered(area):
	if area.is_in_group("player_fire"):
		take_damage()


func _on_bottom_sprite_animation_finished():
	queue_free()
