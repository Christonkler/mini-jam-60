extends Resource
class_name MapData

@export_group("Map Visuals")
@export var trash_heap_map : PackedVector2Array
@export var trash_heap_nodes : Array[Array]
@export var level_map : Array[Dictionary]
@export var level : int = 0
@export var texture_button_data : Array[Array]
@export var current_node : Vector2
@export var beaten_nodes : Array[Vector2]
@export var enemy_data : Dictionary[Vector2, Dictionary] # Maps a node's vector to a dict with enemy data to display

func nodes_connected(node1: Vector2, node2: Vector2) -> bool:
	var found_connection : bool = false
	var node_level : int
	for level in range(len(trash_heap_nodes)):
		for node in trash_heap_nodes[level]:
			if node == node1:
				node_level = level
				break
				
	var current_map : Dictionary
	if node_level != 0:
		current_map = level_map[node_level-1]
		for node in current_map.keys():
			if trash_heap_nodes[node_level-1][node-1] == node2:
				for connection in current_map[node]:
					if trash_heap_nodes[node_level][connection-1] == node1:
						found_connection = true
						break
				
	if not found_connection and node_level < len(trash_heap_nodes)-1:
		current_map = level_map[node_level]
		for node in current_map.keys():
			if trash_heap_nodes[node_level][node-1] == node2:
				for connection in current_map[node]:
					if trash_heap_nodes[level+1][connection-1] == node1:
						found_connection = true
						break
	return found_connection
			
			
		
