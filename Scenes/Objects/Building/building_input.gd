class_name BuildingInput
extends Resource

signal set_cells(cells)
signal erase_cells(cells)
signal add_to_direction(direction, num_additions)
signal input_destroyed

var target_node:Node
