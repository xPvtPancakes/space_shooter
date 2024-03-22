extends CharacterBody2D

const speed = 500

#var health = 3
var TS_flag = false
var can_shoot = true
#var railgun_shots = PlayerVariables.railcharge
var rail_array

@export var blue_shot : PackedScene = preload("res://Scenes/blue_shot.tscn")
@export var blue_bullet : PackedScene = preload("res://Scenes/blue_bullet.tscn")
@export var rail_gun: PackedScene = preload("res://Scenes/Railgun.tscn")

func _ready():
	PlayerVariables.connect("player_damage", _on_player_damage)
	PlayerVariables.connect("triple_shot", _on_TS_signal)
	PlayerVariables.connect("rail_charges", _on_Rail_increase)
	
func get_input():
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed
	if Input.is_action_just_pressed("Railgun") && PlayerVariables.railcharge > 0:
		railgun()
	

	if Input.is_action_pressed("Space"):
		if can_shoot == true:
			shooting()
	#if Input.is_action_just_pressed("Space"):
		#if can_shoot == true:
			#shooting()

func railgun():
	if get_tree().get_nodes_in_group("railgun").is_empty():
		var b = rail_gun.instantiate()
		PlayerVariables.railcharge -= 1
		add_child(b)
		b.transform = $Guns.transform
		can_shoot = false
		await(get_tree().create_timer(3).timeout)
		remove_child(b)
		can_shoot = true


func _on_Rail_increase(increase):
	PlayerVariables.railcharge += increase


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
		can_shoot=false
		await(get_tree().create_timer(0.35).timeout)
		can_shoot=true
	
	else:
		var b = blue_shot.instantiate()
		owner.add_child(b)
		b.transform = $Guns.global_transform
		can_shoot=false
		await(get_tree().create_timer(0.2).timeout)
		can_shoot=true

func _physics_process(_delta):
	get_input()
	move_and_slide()

#func _on_player_diameter_area_entered(area):
	#print(area.name)
	#if area.is_in_group("Enemy"):
		#print("areadamage")

func _on_player_damage(hp_change):
	PlayerVariables.health += hp_change
	TS_flag = false
	
	PlayerVariables.emit_signal("player_health")
	

	if PlayerVariables.health <= 0:
		$Explosion_SE.play()
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




func _on_player_diameter_area_entered(area):
	if area.is_in_group("boss"):
		PlayerVariables.emit_signal("player_damage", -1)
