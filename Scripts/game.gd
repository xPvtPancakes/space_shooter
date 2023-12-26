extends Node2D

var player_health = 3
var max_health = 3
var score = 0
signal hp_change

func _ready():
	hp_change.connect(_on_enemy_fire_health_changed)

func update_health():
	player_health-=1
	if player_health == 3:
		print("health 3")
		#anim.play("3 hp")
	if player_health == 2:
		print("health 2")
		#anim.play("2 hp")
	if player_health == 1:
		print("health 1")
		#anim.play("1 hp")

func _on_enemy_fire_health_changed() -> void:
	print("signal??")
	update_health() 

