extends CharacterBody2D

const speed = 500

var health = 3
var TS_flag = false
var can_shoot = true
var railgun_shots = 3
var rail_array

@export var blue_shot : PackedScene = preload("res://Scenes/blue_shot.tscn")
@export var blue_bullet : PackedScene = preload("res://Scenes/blue_bullet.tscn")
@export var rail_gun: PackedScene = preload("res://Scenes/Railgun.tscn")

func _ready():
	PlayerVariables.connect("player_damage", _on_player_damage)
	PlayerVariables.connect("triple_shot", _on_TS_signal)
	
func get_input():
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed
	if Input.is_action_just_pressed("Railgun") && railgun_shots > 0:
		railgun()
	

	
	if Input.is_action_just_pressed("Space"):
		if can_shoot == true:
			shooting()

func railgun():
	if get_tree().get_nodes_in_group("railgun").is_empty():
		var b = rail_gun.instantiate()
		railgun_shots -= 1
		add_child(b)
		b.transform = $Guns.transform
		await(get_tree().create_timer(3).timeout)
		remove_child(b)
	


func shooting():
	$Shoot_SE.play()
	if TS_flag == true:
		var b = blue_bullet.instantiate()
		owner.add_child(b)
		b.transform = $Guns.global_transform
		var b2 = blue_bullet.instantiate()
		owner.add_child(b2)
		b2.transform = $Guns2.global_transform
		var b3 = blue_bullet.instantiate()
		owner.add_child(b3)
		b3.transform = $Guns3.global_transform
	
	else:
		var b = blue_shot.instantiate()
		owner.add_child(b)
		b.transform = $Guns.global_transform
	

func _physics_process(_delta):
	get_input()
	move_and_slide()

#func _on_player_diameter_area_entered(area):
	#print(area.name)
	#if area.is_in_group("Enemy"):
		#print("areadamage")

func _on_player_damage(hp_change):
	health += hp_change
	TS_flag = false
	
	PlayerVariables.emit_signal("player_health", health)
	

	if health <= 0:
		$Explosion_SE.play()
		#$Blue_ship_sprite.set_deferred("visible", false)
		$Iframe_Animation.set_deferred("visible", false)
		$player_diameter/CollisionPolygon2D.set_deferred("disabled", true)
		can_shoot = false
	else:
		$Explosion_SE2.play()
		$player_diameter/CollisionPolygon2D.set_deferred("disabled", true)
		#$Blue_ship_sprite.set_deferred("visible", false)
		$Iframe_Animation.play("iframes")
		#$Iframe_Animation.set_deferred("visible", true)
		$Iframe_Timer.start()




func _on_timer_timeout():
	$player_diameter/CollisionPolygon2D.set_deferred("disabled", false)
	$Iframe_Animation.play("default")
	#$Blue_ship_sprite.set_deferred("visible", true)
	#$Iframe_Animation.set_deferred("visible", false)

func _on_TS_signal(TSFlag):
	TS_flag = TSFlag



func _on_explosion_se_finished():
	queue_free()
