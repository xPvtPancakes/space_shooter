extends Area2D
var x = 170
var initalpos = 0
var health = 30
var rng = RandomNumberGenerator.new()

var can_shoot
var enemy_rail = load("res://Scenes/Enemy_Railgun.tscn")
var nose_bullet = load("res://Scenes/nose_bullet.tscn")
@onready var Nose = [$Nose1, $Nose2, $Nose3, $Nose4]
# Called when the node enters the scene tree for the first time.
func _ready():
	await(get_tree().create_timer(2).timeout)
	move_rail()

func move_rail():
	var MoveVec = initalpos
	for i in 17:
		initalpos = 10
		$Top_sprite.position.x += initalpos
		$CollisionPolygonTop.position.x += initalpos
		$Bottom_sprite.position.x += initalpos 
		$CollisionPolygonBottom.position.x += initalpos
		await(get_tree().create_timer(0.02).timeout)
	railgun()
func railgun():
	
	if get_tree().get_nodes_in_group("enemy_rail").is_empty():
		var b = enemy_rail.instantiate()
		var b2 = enemy_rail.instantiate()
		add_child(b)
		add_child(b2)
		b.transform = $Rail.transform
		b2.transform = $Rail2.transform
		
		await(get_tree().create_timer(2).timeout)
		var MoveVec = x
		for i in 18:
			
			MoveVec = 30
			b. position.x -= MoveVec
			b2.position.x -= MoveVec
			$Top_sprite.position.x -= MoveVec
			$Bottom_sprite.position.x -= MoveVec
			$CollisionPolygonTop.position.x -= MoveVec
			$CollisionPolygonBottom.position.x -= MoveVec
			
			await(get_tree().create_timer(0.05).timeout)
		
		await(get_tree().create_timer(2).timeout)
		remove_child(b)
		remove_child(b2)
		for i in 37:
			MoveVec = 10
			$Top_sprite.position.x += MoveVec
			$Bottom_sprite.position.x += MoveVec
			$CollisionPolygonTop.position.x += MoveVec
			$CollisionPolygonBottom.position.x += MoveVec
			
			await(get_tree().create_timer(0.025).timeout)
			
		
	await(get_tree().create_timer(3).timeout)
	ThrowChin()

func ThrowChin():

	var moveMe = Vector2(0, 0)
	var initial_bot_pos = $CollisionPolygonBottom.position
	var rand_dir = rng.randf_range(-10, 10)
	print($CollisionPolygonBottom.position)
	for i in 50:
		moveMe = Vector2(rand_dir, 15)
		$Bottom_sprite.rotation += PI/3
		$CollisionPolygonBottom.global_rotation += PI/3
		$Bottom_sprite.position += moveMe
		$CollisionPolygonBottom.global_position += moveMe
		await(get_tree().create_timer(0.05).timeout)
		
	$Bottom_sprite.rotation = PI/2
	$Bottom_sprite.position = Vector2(-176, 0)
	$CollisionPolygonBottom.rotation = 0
	$CollisionPolygonBottom.position = initial_bot_pos + Vector2(40, 0)
	print($CollisionPolygonBottom.position)
	$ReloadSE.play()
	for i in 20:
		$Bottom_sprite.position.x -= 4
		$CollisionPolygonBottom.position.x -= 4
		await(get_tree().create_timer(0.01).timeout)
	for i in 10:
		$Bottom_sprite.position.x += 4
		$CollisionPolygonBottom.position.x += 4
		await(get_tree().create_timer(0.01).timeout)
	await(get_tree().create_timer(3).timeout)
	print($CollisionPolygonBottom.position)
	shooting()

func shooting():
	
	for i in 18:
		$Top_sprite.rotation -= PI/36
		$Bottom_sprite.rotation -= PI/36
		$Bottom_sprite.position += Vector2(12, 12)
		$CollisionPolygonTop.rotation -= PI/36
		$CollisionPolygonBottom.rotation -= PI/36
		$CollisionPolygonBottom.position += Vector2(12,12)
		await(get_tree().create_timer(0.01).timeout)
	await(get_tree().create_timer(0.5).timeout)
	for h in 3:
		for i in 4:
			var b = nose_bullet.instantiate()
			get_tree().root.add_child(b)
			b.transform = Nose[i].global_transform
		await(get_tree().create_timer(0.2).timeout)
	for i in 18:
		#sprite movement
		$Top_sprite.rotation += PI/36
		$Bottom_sprite.rotation += PI/36
		$Bottom_sprite.position -= Vector2(12, 12)
		#collision movement
		$CollisionPolygonTop.rotation += PI/36
		$CollisionPolygonBottom.rotation += PI/36
		$CollisionPolygonBottom.position -= Vector2(12,12)
		await(get_tree().create_timer(0.01).timeout)
		
	await(get_tree().create_timer(3).timeout)
	move_rail()
func damage_taken():
	pass
