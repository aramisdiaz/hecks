extends Node2D

const BattleUnits = preload("res://BattleUnits.tres")

export(int) var hp = 25 setget set_hp
export(int) var damage = 4

onready var hpLabel = $HPLabel
onready var animationPlayer = $AnimationPlayer

signal died
signal end_turn
signal victor

func set_hp(new_hp):
	hp = new_hp
	if hpLabel != null:
		hpLabel.text = str(hp) + " HP"
	
	if hp <= 0:
		emit_signal("died")
		queue_free()


func _ready():
	BattleUnits.Enemy = self
	
func _exit_tree():
	BattleUnits.Enemy = null


func attack() -> void:
	yield(get_tree().create_timer(0.4), "timeout")
	animationPlayer.play("Attack")
	yield(animationPlayer, "animation_finished")
	if !is_victor():
		emit_signal("end_turn")
	
func deal_damage():
	BattleUnits.PlayerStats.hp -= damage
	if is_victor():
		emit_signal("victor")
		print("Game over!")

func take_damage(amount):
	self.hp -= amount
	if is_dead():
		emit_signal("died")
		queue_free()
	else:
		animationPlayer.play("Shake")
	
func is_dead():
	return hp <= 0
	
func is_victor():
	return BattleUnits.PlayerStats.hp <= 0

