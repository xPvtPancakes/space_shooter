extends Area2D

var speed = 300
var rng = RandomNumberGenerator.new().randf_range(0, 2)
var rng2 = RandomNumberGenerator.new().randf_range(0, 2)
var pos_modifier_x
var pos_modifier_y
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func pos(from_game_x):
	pos_modifier_x=from_game_x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement = Vector2(speed*delta*rng*pos_modifier_x, speed*delta*rng2)
	global_translate(movement)
	#position += transform.y * speed * delta * rng
	rotation += delta * rng
	#rotate(PI/18)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	if area.name == "player_diameter":
		PlayerVariables.emit_signal("player_damage", -1)
		queue_free()
	if area.name == "Railgun":
		queue_free()
