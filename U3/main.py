import matplotlib.pyplot as plt
from graph_reader import read_graph, read_nodes_names  # Import graph loading functions
from shortest_path import ShortestPath  # Class for working with paths

# Path to the graph file (with weights or unweighted)
file = './U3/data/graph_unweighted.txt'

# Path to the municipality file
municipalities_file = './U3/data/municipalities_nearest_nodes.txt'

# Load graph and coordinates
G, C = read_graph(file)

# Load municipalities
municipalities = read_nodes_names(municipalities_file)

##########
# Example graph (G) and coordinates (C) for testing
G = {
    1 : {2:8, 3:4, 5:2},
    2 : {1:8, 3:5, 4:2, 7:6, 8:7},
    3 : {1:4, 2:5, 6:3, 7:4},
    4 : {2:2, 9:3},
    5 : {1:2, 6:5},
    6 : {3:3, 5:5, 7:5, 8:7, 9:10},
    7 : {2:6, 3:4, 6:5, 8:10},
    8 : {2:7, 6:7, 7:10, 9:1},
    9 : {4:3, 6:10, 8:1}
}

# Coordinates for plotting
C = {
    1 : [95, 322],
    2 : [272, 331],
    3 : [173, 298],
    4 : [361, 299],
    5 : [82, 242],
    6 : [163, 211],
    7 : [244, 234],
    8 : [333, 225],
    9 : [412, 196]
}

# Municipality names and their coordinates
municipalities = {
    'Kostelec': [95, 322],
    'Skořice': [272, 331], 
    #'Bukovník': [173, 298], 
    'Dobršín': [361, 299], 
    'Přestavlky': [82, 242], 
    #'Milínov': [163, 211], 
    'Žákava': [244, 234], 
    'Hněvnice': [333, 225], 
    'Bílov': [412, 196], 
}
###########

# Print the graph and coordinates
print("Graph (G):", G)
print("Coordinates (C):", C)

# Print municipalities
print("Municipalities:", municipalities)

# Create an empty dictionary for municipalities and their corresponding nodes
municipality_to_node = {}

# For each municipality in the list
for municipality, (x, y) in municipalities.items():
    # For each node and its coordinates
    for node, coords in C.items():
        # If the municipality's coordinates match the node's coordinates, assign the node to the municipality
        if coords == [x, y]:
            municipality_to_node[municipality] = node

# Print each municipality and its corresponding node
for municipality, node in municipality_to_node.items():
    print(f"Municipality: {municipality}, Node: {node}")

########## PATH CALCULATION ###########

# Create an object to work with shortest paths
SP = ShortestPath(G)

# BFS and DFS for the starting node
start_node = 1  # Starting node
P = SP.BFS(start_node)
print("BFS Path from Node", start_node, ":", P)

P = SP.DFS(start_node)
print("DFS Path from Node", start_node, ":", P)


##############
# Find all shortest paths
all_paths = SP.all_shortest_paths()
print("All shortest paths:", all_paths)

# Find the specific path from node 1 to 9
start_node = 1
end_node = 9

# Check if path exists and use rec_path to get it
path = SP.rec_path(start_node, end_node, SP.BFS(start_node))  # Path from 1 to 9
print(f"Path from {start_node} to {end_node}:", path)

# First, plot the graph
SP.plot_graph(C)

# Then, plot the shortest path if it exists
if path:
    SP.plot_path(path, C)  # This will plot the path using the 'path' and the 'C' coordinates

# Optionally, plot municipalities as black points
for municipality, (x, y) in municipalities.items():
    plt.plot(x, y, 'ko')
    plt.text(x, y, municipality, fontsize=9, ha='right')

# Set title and show the plot
plt.title(f"Shortest Path from {start_node} to {end_node}")
plt.show()
##############

# Find all shortest paths
all_paths = SP.all_shortest_paths()
print("All shortest paths:", all_paths)

# Find a specific path
path = SP.rec_path(start_node, 9, SP.BFS(start_node))  # Path from 1 to 9
print("Path from", start_node, "to 9:", path)

# Dijkstra's algorithm from node 1 to 9
p, d = SP.dijkstra(1, 9)
print(f"Shortest path from {start_node} to 2: {p} with distance {d}")

# Minimum spanning tree (Prim or Borůvka)
mst, weight = SP.prim()  # Prim's algorithm
print("Prim's MST:", mst, "with weight:", weight)

mst_b, weight_b = SP.boruvka()  # Borůvka's algorithm
print("Borůvka's MST:", mst_b, "with weight:", weight_b)

# Plot the graph
plt.figure(figsize=(12, 12))

# Plot the graph edges
for node, neighbors in G.items():
    if node in C:
        x, y = C[node]
        for neighbor in neighbors:
            if neighbor in C:
                nx, ny = C[neighbor]
                plt.plot([x, nx], [y, ny], 'b-', alpha=0.5)

# Plot the municipalities
for municipality, (x, y) in municipalities.items():
    plt.plot(x, y, 'ro')
    plt.text(x, y, municipality, fontsize=9, ha='right')

SP.plot_path(path, C)
SP.plot_mst(C, mst)

plt.title("Graph Representation of the Road Network with Municipalities")
plt.show()
