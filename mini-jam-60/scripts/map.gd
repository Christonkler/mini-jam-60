extends Control

# Packed vector array to draw
@export var map_data : MapData

var rng = RandomNumberGenerator.new()
var number_of_paths = [1, 2, 3]
var path_weights = PackedFloat32Array([0.5, 2, 0.5])

const NUM_LEVELS : int = 6
const X_NODE_VARIABILITY : float = 0.02
const Y_NODE_VARIABILITY : float = 0.1
const X_SPACE : float = (1.0 / NUM_LEVELS)

const NUM_TRASH_HEAP_TEXTURES = 3

const DEBUG = false

signal node_visible
signal node_invisible
signal move_desc
signal end_game

var trash_heap_sprites = {
	1: preload("res://assets/TrashHeap1.png"),
	2: preload("res://assets/TrashHeap2.png"),
	3: preload("res://assets/TrashHeap3.png")
}
var map_battle_button = preload("res://assets/map_battle_button.png")
var map_used_battle_button = preload("res://assets/used_map_battle_button.png")
var map_battle_button_hover = preload("res://assets/map_battle_button_hover.png")
var map_battle_beaten_button = preload("res://assets/beaten_map_battle_button.png")

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

const enemy_options = [
	[ # Level 0
		{
			"character_image" : "res://assets/people/charlie.png",
			"blade": "res://scenes/beyblade.tscn",
			"description": "You gotta start somewhere, even if it's beating up little kids."
		}
	],
	[ # Level 1
		{
			"character_image" : "res://assets/people/hatman.png",
			"blade": "res://scenes/car_tire.tscn",
			"description": "This guy lives in the junkyard, and has a weird obsession with cars..."
		},
		{
			"character_image" : "res://assets/people/OldMan.png",
			"blade": "res://scenes/scooter_wheel.tscn",
			"description": "Some say he remembers the time before the junkyards"
		},
		{
			"character_image" : "res://assets/people/fidgetman.png",
			"blade": "res://scenes/fidget_spinner.tscn",
			"description": "The kind of guy you'd want to be friends with!"
		}
	],
	[ # Level 2
		{
			"character_image" : "res://assets/people/cruiser.png",
			"blade": "res://scenes/pineapple.tscn",
			"description": "Somehow always finds a way to make a margarita. Don't ask about the ingredients"
		},
		{
			"character_image" : "res://assets/people/doctor.png",
			"blade": "res://scenes/apple.tscn",
			"description": "No one knows if he's a real doctor or not"
		}
	],
	[ # Level 3
		{
			"character_image" : "res://assets/people/bodybuilder.png",
			"blade": "res://scenes/bird.tscn",
			"description": "Made friends with a pet bird. 30 years ago."
		},
		{
			"character_image" : "res://assets/people/turtleguy.png",
			"blade": "res://scenes/turtle_shell.tscn",
			"description": "You're lucky he's out of red shells!"
		}
	],
	[ # Level 4
		{
			"character_image" : "res://assets/people/bombo.png",
			"blade": "res://scenes/explosives.tscn",
			"description": "You're in for a BOOM"
		},
		{
			"character_image" : "res://assets/people/prettyboy.png",
			"blade": "res://scenes/inception_top.tscn",
			"description": "Leo always has a cool prop from his past for us to look at"
		}
	],
	[ # Final boss
		{
			"character_image" : "res://assets/people/World Man.png",
			"blade": "res://scenes/earth.tscn",
			"description": "You don't want to beat this guy"
		}
	]
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Wait for the scene to finish loading so we have the size given to us by the container
	await get_tree().process_frame
	map_data = ResourceLoader.load("user://map_data.res")
	if map_data:
		if map_data.level == NUM_LEVELS:
			end_game.emit()
			
		var new_node : TextureButton
		var i : int = 0
		for level in map_data.trash_heap_nodes:
			for node in level:
				if DEBUG:
					new_node = create_button(node, map_battle_button_hover, map_battle_button)
					new_node.pressed.connect(start_battle.bind(node))
					new_node.mouse_entered.connect(make_visible.bind(node))
					new_node.mouse_exited.connect(make_invisible.bind())
				elif node in map_data.beaten_nodes:
					new_node = create_button(node, map_battle_beaten_button, map_battle_beaten_button)
				elif i < map_data.level:
					new_node = create_button(node, map_used_battle_button, map_used_battle_button)					
				elif (len(map_data.beaten_nodes) == 0 and i == 0) or \
					 (len(map_data.beaten_nodes) and map_data.nodes_connected(node, map_data.beaten_nodes[-1])):
					# TODO: Add a callback to the hover function that displays enemy data texture rect
					new_node = create_button(node, map_battle_button_hover, map_battle_button)
					new_node.pressed.connect(start_battle.bind(node))
					new_node.mouse_entered.connect(make_visible.bind(node))
					new_node.mouse_exited.connect(make_invisible.bind())
				else:
					new_node = create_button(node, map_used_battle_button, map_used_battle_button)
				self.add_child(new_node)
			i += 1
			
		self.queue_redraw()
	else:
		map_data = MapData.new()
		generate_nodes()
		generate_map()
		print(ResourceSaver.save(map_data, "user://map_data.res"))

func make_visible(node) -> void:
	var enemy_picture = load(map_data.enemy_data[node]["character_image"])
	var enemy_description = map_data.enemy_data[node]["description"]
	node_visible.emit(enemy_picture, enemy_description)
	
func make_invisible() -> void:
	node_invisible.emit()

func _draw():
	if len(map_data.trash_heap_map):
		draw_multiline(map_data.trash_heap_map, Color.DARK_RED, 5)
		draw_multiline(map_data.trash_heap_map, Color.BLACK, 3)

func generate_nodes() -> void:
	var x_location : int # Final x position
	var y_location : int # Final y position
	
	var x_static : float # Intermediate x calculation to determine step size
	var y_static : float # Intermediate y calculation to determine window height for node
	
	var num_nodes_in_level : int
	var level_nodes : Array[Vector2]
	var new_node : TextureButton
	var new_style_box = StyleBoxFlat.new()
	new_style_box.bg_color=Color.ALICE_BLUE

	# Iterate through each 'level' of the map
	for level in range(1, NUM_LEVELS+1):
		
		# If this is the first level or the last, only use one node.
		# Good for boss fights / intro level
		if level == 1 or level == NUM_LEVELS:
			num_nodes_in_level = 1
		else:
			# Pick a random number of nodes based on a weight rng function
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
			if level == 1:
				new_node = create_button(Vector2(x_location, y_location), map_battle_button_hover, map_battle_button)
				new_node.pressed.connect(start_battle.bind(Vector2(x_location, y_location)))
				new_node.mouse_entered.connect(make_visible.bind(Vector2(x_location, y_location)))
				new_node.mouse_exited.connect(make_invisible.bind())
			else:
				new_node = create_button(Vector2(x_location, y_location), map_used_battle_button, map_used_battle_button)
			
			self.add_child(new_node)

			level_nodes.append(Vector2(x_location, y_location))
			var chosen_enemy = int(rng.randf_range(0, len(enemy_options[level-1])))
			map_data.enemy_data.set(Vector2(x_location, y_location), enemy_options[level-1][chosen_enemy])
		map_data.trash_heap_nodes.append(level_nodes)
		
func start_battle(node) -> void:
	var arena_pack = load("res://scenes/arena.tscn")
	var arena = arena_pack.instantiate()
	var enemies_available = len(enemy_options[map_data.level])
	var enemy = load(map_data.enemy_data[node]["blade"]).instantiate()

	arena.get_node("Control").enemy = enemy
	arena.get_node("Control").add_child(enemy)
	
	if not DEBUG:
		map_data.level += 1
		map_data.beaten_nodes.append(node)
	if map_data.level == NUM_LEVELS:
		arena.get_node("Control").last_boss = true
	ResourceSaver.save(map_data, "user://map_data.res")
	get_tree().change_scene_to_node(arena)
		
func create_button(pos: Vector2, texture_hover: Texture2D, texture_normal: Texture2D) -> TextureButton:
	var new_node : TextureButton
	new_node = TextureButton.new()
	new_node.texture_normal = texture_normal
	new_node.texture_hover = texture_hover
	new_node.size = map_battle_button.get_size()
	new_node.position = Vector2(pos.x - (new_node.size.x / 2), pos.y - (new_node.size.y / 2))
	return new_node

func generate_map() -> void:
	var cur_level_nodes : int
	var next_level_nodes : int
	var map_options: Array
	
	var line_start : Vector2
	var line_end : Vector2
	var chosen_map : Dictionary
	var chosen_end_points : Array
	
	# Iterate through all the levels
	for level in range(len(map_data.trash_heap_nodes)-1):
		cur_level_nodes = len(map_data.trash_heap_nodes[level])
		next_level_nodes = len(map_data.trash_heap_nodes[level+1])
		
		# Get all map options for this input / output combination
		map_options = path_map_options[cur_level_nodes-1][next_level_nodes-1] # -1 since we're 0 indexed
		
		# Randomly choose a map
		chosen_map = map_options[rng.randf_range(0, len(map_options))]
		map_data.level_map.append(chosen_map)
		
		# Iterate through the dictionary and create the vectors
		for key in chosen_map.keys():
			line_start = map_data.trash_heap_nodes[level][key-1]
			
			# Get the list of endpoints this starting node maps to
			chosen_end_points = chosen_map[key]
			
			# Append each vector
			for end_point in chosen_end_points:
				line_end = map_data.trash_heap_nodes[level+1][end_point-1] # -1 since we're 0 indexed
				map_data.trash_heap_map.append(line_start)
				map_data.trash_heap_map.append(line_end)
	
	self.queue_redraw()
