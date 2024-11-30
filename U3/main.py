from matplotlib import pyplot as plt
from graph_reader import read_graph, read_nodes_names  # Import graph loading functions
from graph_path_finder import GraphPathFinder  # Class for working with paths

# Path to the graph file (could be weighted or unweighted)
file = './U3/data/graph_unweighted.txt'

# Path to the municipality file
municipalities_file = './U3/data/municipalities_nearest_nodes.txt'

# Load graph and coordinates
G, C = read_graph(file)

# Load municipality coordinates
municipalities = read_nodes_names(municipalities_file)

# Create a dictionary to map municipalities to corresponding nodes
municipality_to_node = {}

# For each municipality and its coordinates
for municipality, (x, y) in municipalities.items():
    # Find the corresponding node with the same coordinates
    for node, coords in C.items():
        if coords == [x, y]:
            municipality_to_node[municipality] = node

# Take input for the starting and ending nodes
start_node_name = input("Enter the starting node name: ")
end_node_name = input("Enter the ending node name: ")

# Find the corresponding nodes for the start and end municipalities
start_node = municipality_to_node.get(start_node_name, None)
end_node = municipality_to_node.get(end_node_name, None)

# Check if both start and end nodes are valid
if start_node is None:
    print(f"Start node '{start_node_name}' not found.")
if end_node is None:
    print(f"End node '{end_node_name}' not found.")
if start_node is not None and end_node is not None:
    print(f"Start node '{start_node_name}' corresponds to node {start_node}; End node '{end_node_name}' corresponds to node {end_node}")

# Create an object to work with shortest paths
SP = GraphPathFinder(G)

# BFS for the starting node
P = SP.BFS(start_node)
print("BFS Path from Node", start_node, ":", P)

# DFS for the starting node
P = SP.DFS(start_node)
print("DFS Path from Node", start_node, ":", P)

# Find all shortest paths
all_paths = SP.all_shortest_paths()
print("All shortest paths:", all_paths)

P, dmin = SP.shortest_cost_path(start_node, end_node)

# Find the specific path from node start to end
path = SP.rec_path(start_node, end_node, P)
print(f"Path from {start_node} to {end_node}:", path)

# Set the figure size
plt.figure(1, figsize=(10, 10))

# First, plot the graph
SP.plot_graph(C)

# Plot the starting and ending nodes as larger red dots
SP.plot_red_nodes({start_node, end_node}, C)

# If path exist then, plot the shortest path if it exists
if path:
    SP.plot_path(path, C)

# Plot the municipality names in black with small font, white halo, and thin black text
SP.plot_node_names(municipalities)

# Set title, axis and show the plot
plt.title(f"Shortest Path from {start_node_name} to {end_node_name}")
plt.gca().set_aspect('equal', adjustable='box')
plt.show(block=False)

# Dijkstra's algorithm
p, d = SP.dijkstra(start_node, end_node)
print(f"Shortest path using Dijkstra's algorithm from {start_node} to {end_node}: {SP.rec_path(start_node, end_node, p)} with weight {d}")

# Bellman-Ford algorithm
p, d = SP.bellman_ford(start_node, end_node)
print(f"Shortest path using Bellman-Ford algorithm from {start_node} to {end_node}: {SP.rec_path(start_node, end_node, p)} with weight {d}")

# Minimum spanning tree Prim's algorithm
mst_p, weight_p = SP.prim()
print(f"Prim's Minimum Spanning Tree: {mst_p} with total weight: {weight_p}")

# Plot the graph
plt.figure(2, figsize=(8, 8))

# First, plot the graph
SP.plot_graph(C)

# Plot the municipality names in black with small font, white halo, and thin black text
SP.plot_node_names(municipalities)

# SP.plot_path(path, C)
SP.plot_mst(C, mst_p, line='r-')

# Set title, axis and show the plot
plt.title("MST according to Prim's algorithm")
plt.gca().set_aspect('equal', adjustable='box')
plt.show(block=False)

# Minimum spanning tree Borůvka's algorithm
mst_b, weight_b = SP.boruvka() 
print(f"Borůvka's Minimum Spanning Tree: {mst_b} with total weight: {weight_b}")

# Plot the graph
plt.figure(3, figsize=(10, 10))

# First, plot the graph
SP.plot_graph(C)

# Plot the municipality names in black with small font, white halo, and thin black text
SP.plot_node_names(municipalities)

# SP.plot_path(path, C)
SP.plot_mst(C, mst_b, line='r-')

# Set title, axis and show the plot
plt.title("MST according to Borůvka's algorithm")
plt.gca().set_aspect('equal', adjustable='box')  # Equal aspect ratio for X and Y axes
plt.show()