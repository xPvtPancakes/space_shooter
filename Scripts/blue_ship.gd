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

func _physics_process(delta):
	get_input()
	move_and_slide()

#func _on_player_diameter_area_entered(area):
	#print(area.name)
	#if area.is_in_group("Enemy"):
		#print("areadamage")

func _on_player_damage():
	health -= 1
	PlayerVariables.emit_signal("player_health", health)
	if health <= 0:
		queue_free()
