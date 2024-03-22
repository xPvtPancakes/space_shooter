extends Area2D

@onready var Shield_anim = $Shield
var shield_hp = str(PlayerVariables.shield)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Shield_anim.play("hp" + shield_hp)


func _on_area_entered(area):
	if area.is_in_group("Enemy") or area.is_in_group("Boss") or area.is_in_group("Comet"):
		PlayerVariables.shield -= 1
		shield_hp = str(PlayerVariables.shield)
