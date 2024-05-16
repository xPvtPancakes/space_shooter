extends Area2D
var x = 170
var initalpos = 0
var health = 20
var rng = RandomNumberGenerator.new()

var can_shoot
var enemy_rail = load("res://Scenes/Enemy_Railgun.tscn")
var nose_bullet = load("res://Scenes/nose_bullet.tscn")
@onready var Nose = [$Nose1, $Nose2, $Nose3, $Nose4]
# Called when the node enters the scene tree for the first time.
func _ready():
	await(get_tree().create_timer(2).timeout)
	move_rail()
	PlayerVariables.connect("chinthrowfinished", _on_ThrowChin_finished)

func move_rail():
	var MoveVec = initalpos
	for i in 17:
		initalpos = 10
		$Top_sprite.position.x += initalpos
		$CollisionPolygonTop.position.x += initalpos

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
		PlayerVariables.emit_signal("rail")
		var MoveVec = x
		for i in 18:
			
			MoveVec = 30
			b. position.x -= MoveVec
			b2.position.x -= MoveVec
			$Top_sprite.position.x -= MoveVec
			$CollisionPolygonTop.position.x -= MoveVec

			
			await(get_tree().create_timer(0.05).timeout)
		
		await(get_tree().create_timer(2).timeout)
		remove_child(b)
		remove_child(b2)
		for i in 37:
			MoveVec = 10
			$Top_sprite.position.x += MoveVec

			$CollisionPolygonTop.position.x += MoveVec

			
			await(get_tree().create_timer(0.025).timeout)
			
		
	await(get_tree().create_timer(3).timeout)
	PlayerVariables.emit_signal("chinthrow")
	await (get_tree().create_timer(5.8).timeout)
	shooting()
func _on_ThrowChin_finished():
	pass
	
		#shooting()
func shooting():
	PlayerVariables.emit_signal("shooting")
	for i in 18:
		$Top_sprite.rotation -= PI/36
		$CollisionPolygonTop.rotation -= PI/36

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
		#collision movement
		$CollisionPolygonTop.rotation += PI/36

		await(get_tree().create_timer(0.01).timeout)
		
	await(get_tree().create_timer(3).timeout)
	move_rail()
	
func damage_taken():
	health -= 1
	if health <= 0:
		PlayerVariables.emit_signal("score_up", 5000)
		PlayerVariables.emit_signal("headdead")
		PlayerVariables.emit_signal("third_boss")
		$Top_sprite.scale = Vector2(1, 1)
		$Top_sprite.play("explosion")
		$Explosion.play()


func _on_area_entered(area):
	if area.is_in_group("player_fire"):
		damage_taken()


func _on_top_sprite_animation_finished():
	queue_free()
