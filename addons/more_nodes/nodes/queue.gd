extends Node
class_name Queue

signal all_complete
signal func_complete(func_name)
var _connect

export (bool) var autostart = true
export (NodePath) var base_node_path
export (bool) var logging_enabled = true

var base_node:Node = null

var queue:Array = []
var is_playing:bool = false


func _init(base_node_value:Node=null, autostart_value:bool=true, logging_enabled_value:bool=true) -> void:
	base_node = base_node_value
	autostart = autostart_value
	logging_enabled = logging_enabled_value


func _enter_tree() -> void:
	if base_node_path and not base_node:
		base_node = get_node_or_null(base_node_path)
	
	if autostart:
		start()


#func setup(new_base_node:Node, to_autostart:bool=true) -> void:
#	""" setup
#
#		Constructor to help set up node after ready. Don't use setup if the
#		queue is already in the scene tree.
#	"""
#	base_node = new_base_node
#	base_node.add_child(self)
#
#	autostart = to_autostart
#	if to_autostart and not is_playing:
#		start()


func start() -> void:
	if logging_enabled:
		print("QUEUE (", base_node, "): Starting queue...")
	
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
	if logging_enabled:
		print("QUEUE (", base_node, "): Stopping queue...")
	
	disconnect("func_complete", self, "call_next")


func add_func(func_name:String, args:Array=[], to_yield:bool=false) -> void:
	if logging_enabled:
		print("QUEUE (", base_node, "): Added <", func_name, ">")
		
	queue.append({
		func_ref = funcref(base_node, func_name),
		args = args,
		to_yield = to_yield,
		func_name = func_name
	})
	if autostart and not is_playing:
		call_next()


func remove_func(func_name:String) -> void:
	if logging_enabled:
		print("QUEUE (", base_node, "): Removed <", func_name, ">")
	
	var i:int = 0
	for queue_item in queue:
		var current_name:String = queue_item.func_name
		if current_name == func_name:
			queue.remove(i)
			break
		i += 1


func call_func(func_dict:Dictionary) -> void:
	if logging_enabled:
		print("QUEUE (", base_node, "): Calling <", func_dict.func_name, ">")
	
	yield(base_node.get_tree(), "idle_frame")
	if func_dict.to_yield:
		yield(func_dict.func_ref.call_funcv(func_dict.args), "completed")
	else:
		func_dict.func_ref.call_funcv(func_dict.args)
	queue.erase(func_dict)
	emit_signal("func_complete", func_dict.func_name)
