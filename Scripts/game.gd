extends Node2D

var player_health = 3
#@export var Enemy_scene: PackedScene
var enemy = preload("res://Scenes/green_enemy.tscn")
var tri_shot = preload("res://Scenes/triple_shot_powerup.tscn")
var score = 0
signal hp_change
var rng = RandomNumberGenerator.new()
var kill_counter = 0
#@onready var anim = get_node ("AnimatedSprite2D")

func _ready():
	#PlayerVariables.connect("player_damage", _on_player_damage)
	PlayerVariables.connect("score_up", _on_score_up)
	PlayerVariables.connect("player_health", _on_health_change)
	$Lives_label.text = ": " + str(player_health)
	New_game()
	#spawn_enemies()




func _on_score_up(adj_score):
	score += adj_score
	$Score_label.text = str(score)
	
	kill_counter += 5
	if kill_counter == 10:
		var x_rand_num =rng.randf_range(50, 1000)
		var tri_shot_spawn = Vector2(0, 0)
		var p = tri_shot.instantiate()
		tri_shot_spawn.x = x_rand_num
		p.position = tri_shot_spawn
		add_child(p)
		kill_counter=0



func _on_health_change(current_health):
	player_health=current_health
	$Lives_label.text = ": " + str(player_health)
	$blue_ship.position = $Start_position.position
	if player_health == 0:
		if self.is_in_group("enemy"):
			queue_free()
		Game_over()
	
func New_game():
	$blue_ship.position = $Start_position.position
	$StartTimer.start()
	
func Game_over():
	$EnemyTimer.stop()
	$GameOver.set_deferred("visible", true)
	

func _on_start_timer_timeout():
	$EnemyTimer.wait_time = randf_range(2,6)
	$EnemyTimer.start()
	





func _on_enemy_timer_timeout():
	var rand_num =rng.randf_range(-10, 10)
	var y_rand_num = rng.randf_range(20, 300)
	var enemy_spawn_location = Vector2(0, 0)
	var e = enemy.instantiate()
	if rand_num >= 0:
		enemy_spawn_location.x = 0

		enemy_spawn_location.y = y_rand_num
		print(enemy_spawn_location)
		print("zone 1")
	else:
		enemy_spawn_location.x = get_viewport_rect().size.x

		enemy_spawn_location.y = y_rand_num
		print("zone 2")

	e.position = enemy_spawn_location
	add_child(e)
	e.start(enemy_spawn_location)


