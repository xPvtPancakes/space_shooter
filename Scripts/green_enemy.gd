extends CharacterBody2D

@export var enemy_fire : PackedScene = preload("res://Scenes/enemy_fire.tscn")


func shooting():
	var b = enemy_fire.instantiate()
	owner.add_child(b)
	b.transform = $Guns.global_transform


func _on_timer_timeout():
	shooting()

