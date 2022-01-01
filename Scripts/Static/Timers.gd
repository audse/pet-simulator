extends Node

func wait(time:float=0.01) -> void:
	yield(get_tree().create_timer(time), "timeout")

static func start_new(node, time:float=1, connect_to:String="") -> Timer:
	var timer:Timer = Timer.new()
	timer.wait_time = time
	node.add_child(timer)
	
	if len(connect_to) > 0:
		var _connect = timer.connect("timeout", node, connect_to)
	
	timer.start()
	return timer
