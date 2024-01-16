extends CharacterBody2D

@export var enemy_fire : PackedScene
var health = 20

func shooting():
	var b = enemy_fire.instantiate()
	get_tree().root.add_child(b)
	b.transform = $Gun1.global_transform

func _on_shoot_timer_timeout():
	shooting()

func health_loss():
	health -= 1
	if health <= 0:
		queue_free()



func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
		health_loss()
