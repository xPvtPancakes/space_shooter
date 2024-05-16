extends Node2D

signal player_damage
signal score_up(score)
signal player_health()
signal triple_shot(flag)
signal first_boss()
signal second_boss()
signal third_boss()
signal rail_charges(change)
signal ship_color
signal shield(value)
var railcharge = 0
var health = 3

#boss 3 signals
signal chinthrow
signal rail
signal shooting
signal chinthrowfinished
signal headdead


func _ready():
	pass
