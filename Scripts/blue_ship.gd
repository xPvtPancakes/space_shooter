extends CharacterBody2D

const speed = 500

var health = 1

@export var blue_shot : PackedScene = preload("res://Scenes/blue_shot.tscn")

func _ready():
	PlayerVariables.connect("player_damage", _on_player_damage)
	
func get_input():
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed
	#var pos = $Blue_ship_sprite.position
	#pos.x = clamp(pos.x, 0, get_viewport_rect().size.x)
	#pos.y = clamp(pos.y, 0, get_viewport_rect().size.y)
	#global_position = pos
	
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
	print("you changed health to 1 in the blue-ship scene")

	
	if health <= 0:
		queue_free()
	$Iframe_Timer.start()




func _on_timer_timeout():
	$DamagePolygon.set_deferred("disabled", false)
	$Blue_ship_sprite.set_deferred("visible", true)
	$Iframe_Animation.set_deferred("visible", false)

