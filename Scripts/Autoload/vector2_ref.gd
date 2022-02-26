class_name Vector2Ref
extends Object


static func normalize_to_one(vector:Vector2) -> Vector2:
	if vector.x < -1:
		vector.x = -1
	elif vector.x > 1:
		vector.x = 1
	if vector.y < -1:
		vector.y = -1
	elif vector.y > 1:
		vector.y = 1
	return vector

