class_name FateData
extends Resource

signal amount_changed(new_amount)

var amount:int = 100 setget set_amount, get_amount


func _init(amount_value:int=amount) -> void:
	amount = amount_value


func set_amount(amount_value:int) -> void:
	amount = amount_value
	emit_signal("amount_changed", amount)


func get_amount() -> int:
	return amount


func load_save_data(save_data:Dictionary) -> void:
	if "amount" in save_data:
		self.amount = save_data["amount"]
	

func collect_save_data() -> Dictionary:
	return {
		"amount": amount
	}
	
