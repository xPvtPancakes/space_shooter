extends Node2D

#var player_health = 3
var enemy = preload("res://Scenes/green_enemy.tscn")
var tri_shot = preload("res://Scenes/triple_shot_powerup.tscn")
var shield_pu = preload("res://Scenes/Shield_powerup.tscn")
var first_boss = preload("res://Scenes/1stBoss.tscn")
var second_boss = preload("res://Scenes/2ndBoss.tscn")
var comet = preload("res://Scenes/comet.tscn")
var high_score: int
var SaveFile = ("user://scoresave.tres")
var score = 0
var score_for_life = 0
signal hp_change
var rng = RandomNumberGenerator.new()
var kill_counter = 0
var kill_count_reset = 0
var kills_without_death = 0
var rand_range_x = 0.2
var rand_range_y = 3
var boss_flag_1 = 0
var boss_flag_2 = 0
@onready var LoopPath = $EnemyPath/EnemyPath2D
@onready var path = $BossFight/PathFollow2D
@onready var boss_spawn = $SpawnPath/PathFollow2D
@onready var boss_spawn2 = $SpawnPath2/PathFollow2D


func _ready():
	#PlayerVariables.connect("player_damage", _on_player_damage)
	PlayerVariables.connect("score_up", _on_score_up)
	PlayerVariables.connect("player_health", _on_health_change)
	PlayerVariables.connect("first_boss", _on_first_boss_defeat)
	PlayerVariables.connect("second_boss", _on_second_boss_defeat)
	#PlayerVariables.connect("rail_charges", _on_Rail_shot)
	$Control/RailCharges2.text = str(PlayerVariables.railcharge)
	$Lives_label.text = ": " + str(PlayerVariables.health)
	New_game()

	loadscores()
	#spawn_enemies()

func save(HighScores):
	var file = FileAccess.open(SaveFile, FileAccess.WRITE)
	file.store_32(HighScores)
#
func loadscores():
	var file = FileAccess.open(SaveFile, FileAccess.READ)
	if FileAccess.file_exists(SaveFile):
		var content = file.get_32()
		high_score = content
		$HighScoreLabel.text = str(content)



func _on_score_up(adj_score):
	score += adj_score
	score_for_life += adj_score
	$Score_label.text = str(score)
	
	kill_counter += 1

	if kill_counter == 10:
		var x_rand_num =rng.randf_range(50, 1000)
		var coin_flip = rng.randf_range(0, 1)
		if coin_flip <= 0.5:
			
			var tri_shot_spawn = Vector2(0, 0)
			var p = tri_shot.instantiate()
			tri_shot_spawn.x = x_rand_num
			p.position = tri_shot_spawn
			add_child.call_deferred(p)
			kill_counter=0
			kill_count_reset += 1
			
		if coin_flip > 0.5:
			var pu_spawn = Vector2(0, 0)
			var p = shield_pu.instantiate()
			pu_spawn.x = x_rand_num
			p.position = pu_spawn
			add_child.call_deferred(p)
			kill_counter=0
			kill_count_reset += 1

	kills_without_death += 1
	if kills_without_death >= 40:
		kills_without_death = 0
		PlayerVariables.emit_signal("rail_charges", 1)
	
	if score_for_life > 5000:
		PlayerVariables.health += 1
		score_for_life = 0
		$LifeUp_se.play()
	
	if score > 5000 && boss_flag_1 == 0:
		boss_flag_1 = 1
		Spawn_boss1()
		$EnemyTimer.paused = true
		
	if score > 20000 && boss_flag_1 == 1 && boss_flag_2 == 0:
		boss_flag_2 = 1
		Spawn_boss2()
		$EnemyTimer.paused = true
		
	



func _on_health_change():

	$blue_ship.position = $Start_position.position
	if PlayerVariables.health <= 0:
		Game_over()
	
func New_game():
	$blue_ship.position = $Start_position.position
	$blue_ship.collision_layer = 10
	$StartTimer.start()
	
	
	
func Game_over():
	$EnemyTimer.stop()
	$GameOver.set_deferred("visible", true)
	if score >= high_score:
		save(score)
	$RestartButton.set_deferred("visible", true)
	$RestartButton.set_deferred("disabled", false)
	for i in get_tree().get_nodes_in_group("enemy"):
		i.queue_free()

	

func _on_start_timer_timeout(): #start game
	$EnemyTimer.wait_time = randf_range(rand_range_x,rand_range_y)
	#$EnemyTimer.start()
	$CometTimer.start()
	#expand_viewport()

	




func Spawn_boss1():
	var boss_instance = first_boss.instantiate()
	boss_spawn.progress_ratio = 0
	boss_instance.rotation = -PI/2
	boss_spawn.call_deferred("add_child", boss_instance)

	await(get_tree().create_timer(3).timeout)
	if boss_spawn.progress_ratio > 0.99:
		path.progress_ratio = 0
		boss_spawn.remove_child(boss_instance)
		boss_instance.rotation = 0
		path.add_child(boss_instance)
		
func Spawn_boss2():
	var boss_instance = second_boss.instantiate()
	boss_instance.scale = Vector2(3.5, 3.5)
	boss_instance.rotation = -PI/2
	boss_spawn2.progress_ratio = 0
	boss_spawn2.call_deferred("add_child", boss_instance)

func spawn_comet():
	var comet_instance = comet.instantiate()
	var rand_num = rng.randf_range(0, 30)
	var x_rand_num = rng.randf_range(20, get_viewport_rect().size.x)
	var y_rand_num = rng.randf_range(0, get_viewport_rect().size.y/2)
	var comet_spawn_location = Vector2(0, 0)
	if rand_num <= 10:
		comet_spawn_location.x = 0
		comet_spawn_location.y = y_rand_num
		comet_instance.pos(1)
	if rand_num >= 10 && rand_num < 20:
		comet_spawn_location.x = 0
		comet_spawn_location.y = x_rand_num
		comet_instance.pos(1)

	else:
		comet_spawn_location.x = get_viewport_rect().size.x
		comet_spawn_location.y = y_rand_num
		comet_instance.pos(-1)

	comet_instance.position = comet_spawn_location
	add_child(comet_instance)
	

func _process(delta): #refresh every frame
	path.progress += delta * 200 
	boss_spawn.progress += delta * 200
	boss_spawn2.progress += delta * 200
	LoopPath.progress += delta * 200
	$Control/RailCharges2.text = str(PlayerVariables.railcharge)
	$Lives_label.text = ": " + str(PlayerVariables.health)

	



func _on_enemy_timer_timeout(): #spawn enemies

	if kill_count_reset <= 0:
		spawn_enemy()
	else:
		for i in kill_count_reset+1:
			spawn_enemy()
			await(get_tree().create_timer(0.5).timeout)

	
	
	
func spawn_enemy():
	var rand_num = rng.randf_range(-10, 10)
	var enemy_type = boss_flag_1 + boss_flag_2
	var y_rand_num = rng.randf_range(20, 300)
	var enemy_spawn_location = Vector2(0, 0)
	var e = enemy.instantiate()
	if rand_num >= 0:
		enemy_spawn_location.x = 0
		enemy_spawn_location.y = y_rand_num

	else:
		enemy_spawn_location.x = get_viewport_rect().size.x
		enemy_spawn_location.y = y_rand_num
	e.set_type(enemy_type) #0: green enemy, 1: orange, 2: blue

	
	e.position = enemy_spawn_location
	add_child(e)
	e.start(enemy_spawn_location)

	$EnemyTimer.wait_time = randf_range(rand_range_x,rand_range_y)

	
	

func _on_restart_button_pressed():
	get_tree().reload_current_scene()
	PlayerVariables.health = 3

func _on_first_boss_defeat():
	#$EndOfDemo.set_deferred("visible", true)
	#$EndGame.set_deferred("visible", true)
	#$EndGame.set_deferred("disabled", false)
	$EnemyTimer.paused = false

func _on_second_boss_defeat():
	$EnemyTimer.paused = false

func _on_line_edit_text_submitted(name_entered):
	#Update_Highscores(name_entered)
	pass


func _on_end_game_pressed():
	if score > high_score:
		save(score)
	get_tree().quit()


func _on_comet_timer_timeout():
	spawn_comet()

func expand_viewport():
	var y = get_viewport_rect().size.y
	for i in 500:
		y += 1
		DisplayServer.window_set_size(Vector2i(1152,y))
		await(get_tree().create_timer(0.005).timeout)

#func Update_Highscores(player_name):
	#var name = player_name
	#high_score[name] = score
	#
	#while high_score.size() > 10:
		#var lowest_value = 100
		#for entry in high_score:
			#if high_score[entry] < lowest_value:
				#lowest_value = high_score[entry]
		#
		#for logged in high_score:
			#if high_score[logged] == lowest_value:
				#high_score.erase(logged)
	#order_highscores(high_score)
	#SaveData.save_game()
	#
#func order_highscores(scores: Dictionary) -> Dictionary:
	#var original_dict: Dictionary = high_score.duplicate()
	#var ordered_dict: Dictionary
	#for i in original_dict.size():
		#var highest_score: int = 0
		#for entry in original_dict:
			#if original_dict[entry] > highest_score:
				#highest_score = original_dict[entry]
			#ordered_dict[original_dict.find_key(highest_score)] = highest_score
			#original_dict.erase(original_dict.find_key(highest_score))
	#return ordered_dict
