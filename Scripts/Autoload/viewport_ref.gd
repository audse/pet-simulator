class_name ViewportRef
extends Object


static func from_viewport_position(
	viewport_position:Vector2,
	viewport:Viewport,
	viewport_camera:Camera2D,
	viewport_container:ViewportContainer
) -> Vector2:
	""" from_viewport_position
		transforms a Vector2 position into the corresponding position within
		a given viewport
		
		:param viewport_position: Vector2
			the (local to viewport) position to be transformed
		:param viewport: Viewport
			the viewport to map position out of, should usually be inside
			a viewport container
		:param viewport_camera: Camera2D
			the camera within the viewport, necessary when dealing with
			viewport shrink
		:param viewport_container: ViewportContainer
			the container of current_viewport. if not provided, the method will
			try to get the parent of the viewport
		:returns: Vector2
			the (local to whatever viewport is the parent of the provided
			viewport) position mapped outside the viewport
	"""
	var viewport_stretch := 1
	var viewport_camera_position := Vector2.ZERO
	
	# attempt to get the viewport container, if one is not provided
	if (
		not NodeRef.is_node_valid(viewport_container, ViewportContainer) 
		and NodeRef.is_node_valid(viewport, Viewport)
	):
		viewport_container = viewport.get_parent()
	
	# get transform from viewport
	if NodeRef.is_node_valid(viewport_container, ViewportContainer):
		viewport_stretch = viewport_container.stretch_shrink
	
	# get transform from camera
	if NodeRef.is_node_valid(viewport_camera, Camera2D):
		viewport_camera_position = viewport_camera.get_camera_position()
	
	# transform target position by camera and viewport
	return (viewport_position - viewport_camera_position) * viewport_stretch


static func to_viewport_position(
	position:Vector2, 
	viewport:Viewport,
	viewport_camera:Camera2D,
	viewport_container:ViewportContainer
) -> Vector2:
	""" to_viewport_position (static)
		transforms a Vector2 position into the corresponding position within
		a given viewport
		
		:param position: Vector2
			the (local) position to be transformed
		:param viewport: Viewport
			the viewport to map position into, should usually be inside
			a viewport container
		:param viewport_camera: Camera2D
			the camera within the viewport, necessary when dealing with
			viewport shrink
		:param viewport_container: ViewportContainer
			the container of current_viewport. if not provided, the method will
			try to get the parent of the viewport
		:returns: Vector2
			the (local) position mapped inside the viewport
	"""
	var viewport_stretch := 1
	var viewport_camera_position := Vector2.ZERO
	
	# attempt to get the viewport container, if one is not provided
	if (
		not NodeRef.is_node_valid(viewport_container, ViewportContainer) 
		and NodeRef.is_node_valid(viewport, Viewport)
	):
		viewport_container = viewport.get_parent()
	
	# get transform from viewport
	if NodeRef.is_node_valid(viewport_container, ViewportContainer):
		viewport_stretch = viewport_container.stretch_shrink
	
	# transform target position by camera and viewport
	if NodeRef.is_node_valid(viewport_camera, Camera2D):
		viewport_camera_position = viewport_camera.get_camera_position()
	
	return position - (viewport_camera_position * viewport_stretch)


static func get_viewport_rect(ref_node:Node, parent_viewport:Viewport=null) -> Rect2:
	""" get_viewport_rect
	
		:param ref_node: Node
			the reference node to use for finding transformations. important
			with nested viewports
		:param parent_viewport: Viewport (optional)
			the viewport used to get the size. if left blank, defaults
			to the ref_node's parent viewport
		:returns: Rect2
			returns the global position and size of the given viewport
	"""
	if not NodeRef.is_node_valid(parent_viewport, Viewport):
		parent_viewport = ref_node.get_viewport()
	
	return Rect2(
		# warning-ignore:unsafe_method_access
		ref_node.get_viewport_transform().affine_inverse().origin,
		(
			Vector2.ZERO
			if not NodeRef.is_node_valid(parent_viewport, Viewport)
			else parent_viewport.get_visible_rect().size
		)
	)
