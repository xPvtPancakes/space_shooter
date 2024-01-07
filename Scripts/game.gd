extends Node2D

var player_health = 3
#@export var Enemy_scene: PackedScene
var enemy = preload("res://Scenes/green_enemy.tscn")
var score = 0
signal hp_change
<<<<<<< Updated upstream
=======
var rng = RandomNumberGenerator.new()
>>>>>>> Stashed changes

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
	
func _on_health_change(current_health):
	player_health=current_health
	$Lives_label.text = ": " + str(player_health)
	
func New_game():
	$blue_ship.position = $Start_position.position
	$StartTimer.start()
	


func _on_start_timer_timeout():
<<<<<<< Updated upstream
	$EnemyTimer.start()
=======
	$EnemyTimer.wait_time = randf_range(1,2)
>>>>>>> Stashed changes
	$EnemyTimer.start()


#func _on_enemy_timer_timeout():
	#var enemy = enemy_scene.instantiate()
	#print("enemy timer")
	#var enemy_spawn_location = $EnemySpawn/EnemySpawnLocation
	#enemy_spawn_location.progress_ratio = randf()
	#
	#var direction = enemy_spawn_location.rotation + PI / 2
	#enemy.position = enemy_spawn_location.position
	#
	#add_child(enemy)

#func spawn_enemies():
func _on_enemy_timer_timeout():
	#var e = enemy.instantiate()
	var e = enemy.instantiate()
	#var pos = Vector2(x * (16 + 8) + 24, 16 * 4 + y * 16)
	var enemy_spawn_location = $EnemySpawn/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()
	e.position = enemy_spawn_location.position
	add_child(e)
	e.start(enemy_spawn_location)

func Game_over():
	$EnemyTimer.stop()
	$Game_over.set_deferred("visible", true)
	
	
