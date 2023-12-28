extends Node2D

var player_health

var score = 0
signal hp_change

#@onready var anim = get_node ("AnimatedSprite2D")

func _ready():
	#PlayerVariables.connect("player_damage", _on_player_damage)
	PlayerVariables.connect("score_up", _on_score_up)
	PlayerVariables.connect("player_health", _on_health_change)

	$Lives_label.text = ": " + str(player_health)

#func _on_player_damage(damage):
	#player_health-=1
	
	#print(str(current_health))
	#if current_health == 3:
		#print("health 3")
		#anim.play("3 hp")
	#if player_health == 2:
		#print("health 2")
		##anim.play("2 hp")
	#if player_health == 1:
		#print("health 1")
		##anim.play("1 hp")

func _on_score_up(adj_score):
	score += adj_score
	$Score_label.text = str(score)
	
func _on_health_change(current_health):
	player_health=current_health
	$Lives_label.text = ": " + str(player_health)
	
	
