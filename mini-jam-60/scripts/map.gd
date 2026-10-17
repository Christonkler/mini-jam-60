extends Control

var trash_heap_map : PackedVector2Array
var trash_heap_nodes : Array[Array]
var level_map : Array[Dictionary]
var rng = RandomNumberGenerator.new()	

var number_of_paths = [1, 2, 3]
var path_weights = PackedFloat32Array([0.5, 2, 0.5])

const NUM_LEVELS : int = 6
const X_NODE_VARIABILITY : float = 0.02
const Y_NODE_VARIABILITY : float = 0.1
const X_SPACE : float = (1.0 / NUM_LEVELS)

const NUM_TRASH_HEAP_TEXTURES = 3

var trash_heap_sprites = {
	1: preload("res://assets/TrashHeap1.png"),
	2: preload("res://assets/TrashHeap2.png"),
	3: preload("res://assets/TrashHeap3.png")
}

const path_map_options : Array[Array] = [
	[ # 1 input node
		[ # 1 output node
			{ 
				1: [1]
			}
		],
		[ # 2 output nodes
			{
				1: [1, 2]
			}
		],
		[ # 3 output nodes
			{
				1: [1, 2, 3]
			}
		]
	],
	[ # 2 input nodes
		[ # 1 output node
			{
				1: [1],
				2: [1]
			}
		],
		[ # 2 output nodes
			{
				1: [1],
				2: [2]
			},
			{
				1: [1, 2],
				2: [2]
			},
			{
				1: [1],
				2: [1, 2]
			}
		],
		[ # 3 output nodes
			{
				1: [1],
				2: [2, 3]
			},
			{
				1: [1, 2],
				2: [3]
			},
			{
				1: [1, 2, 3],
				2: [3]
			},
			{
				1: [1],
				2: [1, 2, 3]
			}
		]
	],
	[ # 3 input nodes
		[ # 1 output node
			{
				1: [1],
				2: [1],
				3: [1]
			}
		],
		[ # 2 output nodes
			{
				1: [1, 2],
				2: [2],
				3: [2]
			},
			{
				1: [1],
				2: [1, 2],
				3: [2]
			},
			{
				1: [1],
				2: [1],
				3: [1, 2]
			}
		],
		[ # 3 output nodes
			{
				1: [1],
				2: [2],
				3: [3]
			},
			{
				1: [1, 2],
				2: [2],
				3: [3]
			},
			{
				1: [1],
				2: [1, 2],
				3: [3]
			},
			{
				1: [1],
				2: [2, 3],
				3: [3]
			},
			{
				1: [1],
				2: [2],
				3: [2, 3]
			},
			{
				1: [1, 2],
				2: [2],
				3: [2, 3]
			},
			{
				1: [1, 2, 3],
				2: [3],
				3: [3]
			},
			{
				1: [1],
				2: [1, 2, 3],
				3: [3]
			},
			{
				1: [1],
				2: [1],
				3: [1, 2, 3]
			}
		]
	]
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	# Wait for the scene to finish loading so we have the size given to us by the container
	await get_tree().process_frame
	
	self.generate_nodes()
	self.generate_map()
	
func _draw():
	draw_multiline(trash_heap_map, Color.DARK_RED, 5)
	draw_multiline(trash_heap_map, Color.BLACK, 3)
	
func generate_nodes() -> void:
	var x_location : int # Final x position
	var y_location : int # Final y position
	
	var x_static : float # Intermediate x calculation to determine step size
	var y_static : float # Intermediate y calculation to determine window height for node
	
	var num_nodes_in_level : int
	var level_nodes : Array[Vector2]
	var new_node : Panel
	var new_style_box = StyleBoxFlat.new()
	new_style_box.bg_color=Color.ALICE_BLUE

	# Iterate through each 'level' of the map
	for level in range(1, NUM_LEVELS+1):
		
		# Pick a random number of nodes based on a weight rng function
		if level == 1 or level == NUM_LEVELS:
			num_nodes_in_level = 1
		else:
			num_nodes_in_level = number_of_paths[rng.rand_weighted(path_weights)]
		x_static = self.size.x * (X_SPACE*(level-1))
		y_static = self.size.y / num_nodes_in_level
		
		# Create random node position(s)
		level_nodes = []
		for node in range(num_nodes_in_level):
			
			# Get the location of x +/- the variability
			x_location = int( rng.randf_range( x_static - ( self.size.x * X_NODE_VARIABILITY),
											   x_static + ( self.size.x * X_NODE_VARIABILITY) ) )
			
			# Get the location of y +/- the variability
			y_location = int ( rng.randf_range( ( y_static * node) + ( self.size.y * Y_NODE_VARIABILITY),
												( y_static * (node+1)) - ( self.size.y * Y_NODE_VARIABILITY)))
			
			# Instantiate a new node to be visible here.
			# TODO: Replace these with some sort of interface to show the enemy (or not?)
			new_node = Panel.new()
			new_node.position = Vector2(x_location, y_location)
			new_node.add_theme_stylebox_override('panel', new_style_box)
			new_node.size = Vector2(10,10)
			
			self.add_child(new_node)
			level_nodes.append(Vector2(x_location, y_location))
		trash_heap_nodes.append(level_nodes)

func generate_map() -> void:
	var cur_level_nodes : int
	var next_level_nodes : int
	var map_options: Array
	
	var line_start : Vector2
	var line_end : Vector2
	var chosen_map : Dictionary
	var chosen_end_points : Array
	
	# Iterate through all the levels
	for level in range(len(trash_heap_nodes)-1):
		cur_level_nodes = len(trash_heap_nodes[level])
		next_level_nodes = len(trash_heap_nodes[level+1])
		
		# Get all map options for this input / output combination
		map_options = path_map_options[cur_level_nodes-1][next_level_nodes-1] # -1 since we're 0 indexed
		
		# Randomly choose a map
		chosen_map = map_options[rng.randf_range(0, len(map_options))]
		level_map.append(chosen_map)
		
		# Iterate through the dictionary and create the vectors
		for key in chosen_map.keys():
			line_start = trash_heap_nodes[level][key-1]
			
			# Get the list of endpoints this starting node maps to
			chosen_end_points = chosen_map[key]
			
			# Append each vector
			for end_point in chosen_end_points:
				line_end = trash_heap_nodes[level+1][end_point-1] # -1 since we're 0 indexed
				trash_heap_map.append(line_start)
				trash_heap_map.append(line_end)
	
	#self.add_random_trash_heaps()
	self.queue_redraw()
	
func add_random_trash_heaps() -> void:
	var points : Array[Vector2]
	var current_map : Dictionary
	
	for i in range(len(trash_heap_nodes)-1):
		current_map = level_map[i]
		points = []
		
		if len(trash_heap_nodes[i]) == 1 and len(trash_heap_nodes[i+1]) == 1:
			continue

		for input_node in level_map[i].keys():
			points.append(trash_heap_nodes[i][input_node-1])
				
			for output_node in level_map[i][input_node]:
				points.append(trash_heap_nodes[i+1][output_node-1])
				if len(points) > 2:
					fill_triangle_with_trash(points)
					points.remove_at(0)
				

func fill_triangle_with_trash(points: Array[Vector2]):
	var point1 : Vector2 = points[0]
	var point2 : Vector2 = points[1]
	var point3 : Vector2 = points[2]
	var trash_heap : TextureRect 
	var random_trash_heap_texture : int
	
	var start_x = min(point1.x, point2.x, point3.x) + 20
	var end_x = max(point1.x, point2.x, point3.x) - 20
	var start_y = min(point1.y, point2.y, point3.y) + 20
	var end_y = max(point1.y, point2.y, point3.y) - 20
	
	for x in range(start_x, end_x, 30):
		for y in range(start_y, end_y, 30):
			if in_bounds(Vector2(x,y), point1, point2, point3):
				trash_heap = TextureRect.new()
				trash_heap.position = Vector2(x,y)
				trash_heap.size = Vector2(1,1)
				
				random_trash_heap_texture = rng.randf_range(1, NUM_TRASH_HEAP_TEXTURES+1)
				trash_heap.texture = trash_heap_sprites[random_trash_heap_texture]
				self.add_child(trash_heap)
	
func in_bounds (pt: Vector2, v1: Vector2, v2: Vector2, v3: Vector2) -> bool:
	var d1 : float
	var d2 : float 
	var d3 : float 
	var has_neg : bool
	var has_pos : bool

	d1 = get_sign(pt, v1, v2);
	d2 = get_sign(pt, v2, v3);
	d3 = get_sign(pt, v3, v1);

	has_neg = (d1 < 0) || (d2 < 0) || (d3 < 0);
	has_pos = (d1 > 0) || (d2 > 0) || (d3 > 0);

	return !(has_neg && has_pos);
	
func get_sign (p1: Vector2, p2: Vector2, p3: Vector2) -> float:
	return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
