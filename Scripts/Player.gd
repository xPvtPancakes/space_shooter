extends CharacterBody2D



const speed = 500

var score = 0
var lives = 3
@export var red_shot : PackedScene = preload("res://Scripts/blue_shot.tscn")

func get_input():
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed
	if Input.is_action_just_pressed("Space"):
		shooting()



func shooting():
	var b = red_shot.instantiate()
	owner.add_child(b)
	b.transform = $Guns.global_transform

func _physics_process(delta):
	get_input()
	move_and_slide()


