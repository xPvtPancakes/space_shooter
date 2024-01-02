extends CharacterBody2D

@export var enemy_fire : PackedScene
var start_position = Vector2.ZERO
var speed = 0
@onready var screensize = get_viewport_rect().size

func start(pos):
	speed = 200
	position = Vector2(pos.x, -pos.y)
	start_position = pos
	await get_tree().create_timer(randf_range(0.25, 0.55)).timeout
	var tween = create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position:y", start_position.y, 1.4)
	await tween.finished
	$MoveTimer.wait_time = randf_range(5, 20)
	$MoveTimer.start()
	$ShootTimer.wait_time = randf_range(4,20)
	$ShootTimer.start()
	
func _process(delta):
	position.x += speed * delta
	
	if position.x > screensize.x + 32:
		start(start_position)


func shooting():
	var b = enemy_fire.instantiate()
	get_tree().root.add_child(b)
	b.transform = $Guns.global_transform
	pass



