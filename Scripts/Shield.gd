extends Area2D


@onready var Shield_anim = $Shield
@onready var Collision = [
	0,
	$CollisionPolygon1hp,
	$CollisionPolygon2hp,
	$CollisionPolygon3hp
]
var shield_hp = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerVariables.connect("shield", _on_shield_pickup)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Shield_anim.play("hp" + str(shield_hp))

func _on_shield_pickup(new_shield):
	shield_hp = new_shield
	Shield_anim.play("hp" + str(shield_hp))
	Collision[shield_hp].set_deferred("disabled", false)
	

func _on_area_entered(area):
	if area.is_in_group("enemy") or area.is_in_group("boss") or area.is_in_group("comet") or area.is_in_group("Enemy_fire"):
		shield_hp -= 1
		#shield_hp = str(PlayerVariables.shield)
		Collision[shield_hp + 1].set_deferred("disabled", true)
		if shield_hp > 0:
			Collision[shield_hp].set_deferred("disabled", false)
