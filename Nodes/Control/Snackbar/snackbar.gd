class_name Snackbar
extends MarginContainer

export (bool) var hide_on_start:bool = true

onready var Snackbar = $Panel
onready var positions:Dictionary = {}

onready var queue = Queue.new()

func _ready() -> void:
	yield(get_tree(), "idle_frame")
	
	positions = {
		original = Snackbar.rect_position,
		hidden = Vector2(
			Snackbar.rect_position.x,
			Snackbar.rect_position.y + Snackbar.rect_size.y + 24
		),
	}
	
	if hide_on_start:
		visible = false
		modulate.a = 0
		Snackbar.rect_position = positions.hidden
	
	queue.setup(self, true)


func queue_enter() -> void:
	queue.add_func("enter")


func queue_exit() -> void:
	queue.add_func("exit")


func enter() -> void:
	visible = true
	Tweens.tween(self, "modulate:a", modulate.a, 1, 0.25)
	yield(Tweens.tween(
			Snackbar,
			"rect_position",
			Snackbar.rect_position,
			positions.original,
			0.5
		), "completed")


func exit() -> void:
	yield(Tweens.tween(
			Snackbar,
			"rect_position",
			Snackbar.rect_position,
			positions.hidden,
			0.5
		), "completed")
	visible = false
	modulate.a = 0


func _on_Close_pressed():
	queue_exit()
