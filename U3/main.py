import matplotlib.pyplot as plt
from graph_reader import read_graph, read_nodes_names  # Import graph loading functions
from graph_path_finder import GraphPathFinder  # Class for working with paths

# Path to the graph file (with weights or uncosted)
file = './U3/data/graph_uncosted.txt'

# Path to the municipality file
municipalities_file = './U3/data/municipalities_nearest_nodes.txt'

# Load graph and coordinates
G, C = read_graph(file)

# Load municipalities
municipalities = read_nodes_names(municipalities_file)

# Print the graph, coordinates and municipalities
# print("Graph (G):", G)
# print("Coordinates (C):", C)
# print("Municipalities:", municipalities)

# Take input for the starting and ending nodes
start_node_name = input("Enter the starting node name: ")
end_node_name = input("Enter the ending node name: ")

# Create an empty dictionary for municipalities and their corresponding nodes
municipality_to_node = {}

# For each municipality in the list
for municipality, (x, y) in municipalities.items():
    # For each node and its coordinates
    for node, coords in C.items():
        # If the municipality's coordinates match the node's coordinates, assign the node to the municipality
        if coords == [x, y]:
            municipality_to_node[municipality] = node

print(municipality_to_node)

# Find the corresponding nodes for the start and end municipalities
start_node = municipality_to_node.get(start_node_name, None)
end_node = municipality_to_node.get(end_node_name, None)

print(start_node," ",end_node)

########## PATH CALCULATION ###########

# Create an object to work with shortest paths
SP = GraphPathFinder(G)

# BFS and DFS for the starting node
P = SP.BFS(start_node)
print("BFS Path from Node", start_node, ":", P)

P = SP.DFS(start_node)
print("DFS Path from Node", start_node, ":", P)


##############
# Find all shortest paths
all_paths = SP.all_shortest_paths()
print("All shortest paths:", all_paths)

# Find the specific path from node start to end

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
path = SP.rec_path(start_node, end_node, SP.BFS(start_node))
print("Path from",{start_node},"to",{end_node},":", path)

# Dijkstra's algorithm from node 1 to 9
p, d = SP.dijkstra(start_node, end_node)
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
