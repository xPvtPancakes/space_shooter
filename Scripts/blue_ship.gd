extends CharacterBody2D

const speed = 500

var health = 3
@export var blue_shot : PackedScene = preload("res://Scenes/blue_shot.tscn")

func _ready():
	PlayerVariables.connect("player_damage", _on_player_damage)
	
func get_input():
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed
	if Input.is_action_just_pressed("Space"):
		shooting()



func shooting():
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
	PlayerVariables.emit_signal("player_health", health)
	$DamagePolygon.set_deferred("disabled", true)
	$Blue_ship_sprite.set_deferred("visible", false)
	$Iframe_Animation.play("iframes")
	$Iframe_Animation.set_deferred("visible", true)

	
	if health <= 0:
		queue_free()
	$Iframe_Timer.start()




func _on_timer_timeout():
	$DamagePolygon.set_deferred("disabled", false)
	print("enabled")
	$Blue_ship_sprite.set_deferred("visible", true)
	$Iframe_Animation.set_deferred("visible", false)

