extends CharacterBody2D

const speed = 500

var health
@export var blue_shot : PackedScene = preload("res://Scenes/blue_shot.tscn")

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

func take_damage():
	pass

func _on_player_diameter_area_entered(area):
	print(area.name)
	if area.is_in_group("Enemy"):
		print("areadamage")
