extends CharacterBody2D

const speed = 500

var health = 3
var TS_flag = false
var can_shoot = true

@export var blue_shot : PackedScene = preload("res://Scenes/blue_shot.tscn")
@export var blue_bullet : PackedScene = preload("res://Scenes/blue_bullet.tscn")

func _ready():
	PlayerVariables.connect("player_damage", _on_player_damage)
	PlayerVariables.connect("triple_shot", _on_TS_signal)
	
func get_input():
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed
	#var pos = $Blue_ship_sprite.position
	#pos.x = clamp(pos.x, 0, get_viewport_rect().size.x)
	#pos.y = clamp(pos.y, 0, get_viewport_rect().size.y)
	#global_position = pos
	
	if Input.is_action_just_pressed("Space"):
		if can_shoot == true:
			shooting()



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
		$Blue_ship_sprite.set_deferred("visible", false)
		$Iframe_Animation.set_deferred("visible", false)
		can_shoot = false
	else:
		$Explosion_SE2.play()
		$player_diameter/CollisionPolygon2D.set_deferred("disabled", true)
		$Blue_ship_sprite.set_deferred("visible", false)
		$Iframe_Animation.play("iframes")
		$Iframe_Animation.set_deferred("visible", true)
		$Iframe_Timer.start()




func _on_timer_timeout():
	$player_diameter/CollisionPolygon2D.set_deferred("disabled", false)
	$Blue_ship_sprite.set_deferred("visible", true)
	$Iframe_Animation.set_deferred("visible", false)

func _on_TS_signal(TSFlag):
	TS_flag = TSFlag



func _on_explosion_se_finished():
	queue_free()
