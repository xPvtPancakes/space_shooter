extends Area2D

var hp = 10
var damage_taken = 0
@export var enemy_fire : PackedScene
var charge_sprite = load("res://Scenes/charge_sprite.tscn")

var phase2 = 0

@onready var guns = [
	$Guns1,
	$Guns2,
	$Guns3,
	$Guns4,
	$Guns5,
	$Guns6,
	$Guns7,
	$Guns8,
	$Guns9,
	$Guns10
]

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shooting():
	
	var b = enemy_fire.instantiate()
	var sprite = charge_sprite.instantiate()
	var n = floor(rng.randf_range(0, 10))
	b.speed = 200
	get_tree().root.add_child(b)
	sprite.position = guns[n].global_position
	
	get_tree().root.add_child(sprite)
	
	#sprite.set_deferred("visible", true)
	await get_tree().create_timer(0.5).timeout
	b.transform = guns[n].global_transform
	sprite.queue_free()


func _on_timer_timeout():

	for i in damage_taken:
		shooting()
		await get_tree().create_timer(0.5).timeout

func _on_area_entered(area):
	if area.is_in_group("player_fire") and $Invul_timer.time_left == 0:
		health_loss()
		if damage_taken >= 5:
			phase2 = 1
			swing()

func health_loss():
	hp -= 1
	damage_taken += 1
	$Invul_timer.start()
	if hp <= 0:
		PlayerVariables.emit_signal("second_boss")
		PlayerVariables.emit_signal("score_up", 10000)
		for i in get_tree().get_nodes_in_group("sprite"):
			i.queue_free()
		queue_free()
	
func swing():
	for i in 6:
		$AnimatedSprite2D.rotate(PI/18)
		$CollisionPolygon2D.rotate(PI/18)
		await(get_tree().create_timer(0.05).timeout)
	for i in 20:
		$Whoosh_SE.play()
		$AnimatedSprite2D.rotate(-PI/18)
		$CollisionPolygon2D.rotate(-PI/18)
		await(get_tree().create_timer(0.03).timeout)
	for i in 14:
		$AnimatedSprite2D.rotate(PI/18)
		$CollisionPolygon2D.rotate(PI/18)
		await(get_tree().create_timer(0.03).timeout)
		
		

