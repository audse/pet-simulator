extends Node
class_name Queue

signal all_complete
signal func_complete(func_name)
var _connect

var autostart:bool = true
var base_node:Node
var queue:Array = []
var is_playing:bool = false


func setup(new_base_node:Node, to_autostart:bool=true) -> void:
	base_node = new_base_node
	base_node.add_child(self)
	
	autostart = to_autostart
	if to_autostart:
		start()


func start() -> void:
	_connect = connect("func_complete", self, "call_next")
	if not is_playing:
		call_next()


func call_next(_func_name="") -> void:
	if len(queue) > 0:
		is_playing = true
		yield(call_func(queue[0]), "completed")
	else:
		is_playing = false
		emit_signal("all_complete")


func stop() -> void:
	disconnect("func_complete", self, "call_next")


func add_func(func_name:String, args:Array=[], to_yield:bool=false) -> void:
	queue.append({
		func_ref = funcref(base_node, func_name),
		args = args,
		to_yield = to_yield,
		func_name = func_name
	})
	if autostart and not is_playing:
		call_next()


func remove_func(func_name:String) -> void:
	var i:int = 0
	for queue_item in queue:
		var current_name:String = queue_item.func_ref.get_func()
		if current_name == func_name:
			queue.remove(i)
			break
		i += 1


func call_func(func_dict:Dictionary) -> void:
	yield(base_node.get_tree(), "idle_frame")
	if func_dict.to_yield:
		yield(func_dict.func_ref.call_funcv(func_dict.args), "completed")
	else:
		func_dict.func_ref.call_funcv(func_dict.args)
	queue.remove(queue.find(func_dict))
	emit_signal("func_complete", func_dict.func_name)
