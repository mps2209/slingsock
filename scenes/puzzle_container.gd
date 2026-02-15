extends Node2D

@onready var top_left: PuzzleSlot      = $"Top Left"
@onready var top_middle: PuzzleSlot    = $"Top Middle"
@onready var top_right: PuzzleSlot     = $"Top Right"
@onready var middle_left:PuzzleSlot = $"Middle Left"
@onready var middle: PuzzleSlot        = $Middle
@onready var middle_right: PuzzleSlot  = $"Middle Right"
@onready var bottom_left: PuzzleSlot   = $"Bottom Left"
@onready var bottom_middle: PuzzleSlot = $"Bottom Middle"
@onready var bottom_right: PuzzleSlot  = $"Bottom Right"

var slots: Array[PuzzleSlot] = []


func _ready() -> void:
	# Collect all slots in one array for convenience
	slots = [
		top_left, top_middle, top_right,
		middle_left,middle, middle_right,
		bottom_left, bottom_middle, bottom_right
	]

	# Set up neighbours for a 3x3 grid (by position)
	_init_neighbours()

	# Connect signals from all slots
	for s in slots:
		# assuming the PuzzleSlot has: signal clicked(slot: PuzzleSlot)
		s.clicked.connect(_on_slot_clicked)


func _process(delta: float) -> void:
	pass


func _init_neighbours() -> void:
	# Top row
	top_left.neighbours = [top_middle, middle_left]               # right, down
	top_middle.neighbours = [top_left, top_right, middle]         # left, right, down
	top_right.neighbours = [top_middle, middle_right]             # left, down

	# Middle row
	middle_left.neighbours = [top_left, middle, bottom_left]      # up, right, down
	middle.neighbours = [top_middle, middle_left, middle_right, bottom_middle] # up, left, right, down
	middle_right.neighbours = [top_right, middle, bottom_right]   # up, left, down

	# Bottom row
	bottom_left.neighbours = [middle_left, bottom_middle]         # up, right
	bottom_middle.neighbours = [bottom_left, middle, bottom_right]# left, up, right
	bottom_right.neighbours = [bottom_middle, middle_right]       # left, up right, up
	bottom_right.neighbours = [bottom_middle, middle_right]   # left, up


func _on_slot_clicked(slot: PuzzleSlot) -> void:
	print("on slot clicked " + slot.name)
	# Find an empty neighbour of the clicked slot
	var empty_neighbors := slot.neighbours.filter(
		func(n: PuzzleSlot) -> bool:
			return n.is_empty
	)

	if empty_neighbors.is_empty():
		print("no empty neighbors")
		# No move possible
		return

	var empty_slot: PuzzleSlot = empty_neighbors[0]

	# Get the tile from the clicked slot
	var tile: Node2D = _get_tile_from_slot(slot)
	if tile == null:
		return

	# Move tile to the empty slot
	slot.remove_child(tile)
	empty_slot.add_child(tile)
	tile.position = Vector2.ZERO   # option: align to slot origin

	# Update empty flags
	empty_slot.is_empty = false
	slot.is_empty = true


func _get_tile_from_slot(slot: PuzzleSlot) -> Node2D:
	# Adjust this to your actual structure
	# For example, skip the Label and return the first Node2D child
	for child in slot.get_children():
		if child is PuzzleTile:
			return child
	return null
