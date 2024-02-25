extends Area2D

@export var enemy_fire : PackedScene
var charge_sprite = Sprite2D.new()
@onready var guns = [
	$Guns1,
	$Guns2,
	$Guns3,
	$Guns4,
	$Guns5,
	$Guns6,
	$Guns7,
	$Guns8,
	$Guns9,
	$Guns10
]
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shooting():
	
	var b = enemy_fire.instantiate()
	var n = floor(rng.randf_range(0, 10))
	get_tree().root.add_child(b)
	$EnemyCharge.position = guns[n].position
	$EnemyCharge.set_deferred("visible", true)
	await get_tree().create_timer(0.5).timeout
	b.transform = guns[n].global_transform
	$EnemyCharge.set_deferred("visible", false)


func _on_timer_timeout():
	shooting() # Replace with function body.
