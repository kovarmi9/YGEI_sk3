import matplotlib.pyplot as plt
from graph_reader import read_graph, read_nodes_names  # Import graph loading functions
from graph_path_finder import GraphPathFinder  # Class for working with paths

# Path to the graph file (with weights or uncosted)
file = './U3/data/graph_length_cost.txt'

# Path to the municipality file
municipalities_file = './U3/data/municipalities_nearest_nodes.txt'

# Load graph and coordinates
G, C = read_graph(file)

# Load municipalities
municipalities = read_nodes_names(municipalities_file)

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

# Create an object to work with shortest paths
SP = GraphPathFinder(G)

# BFS and DFS for the starting node
P = SP.BFS(start_node)
print("BFS Path from Node", start_node, ":", P)

P = SP.DFS(start_node)
print("DFS Path from Node", start_node, ":", P)

# Find all shortest paths
all_paths = SP.all_shortest_paths()
print("All shortest paths:", all_paths)

# Find the specific path from node start to end
path = SP.rec_path(start_node, end_node, SP.BFS(start_node))
print(f"Path from {start_node} to {end_node}:", path)

# # First, plot the graph
# SP.plot_graph(C)

# # Then, plot the shortest path if it exists
# if path:
#     SP.plot_path(path, C)  # This will plot the path using the 'path' and the 'C' coordinates

# # Optionally, plot municipalities as black points
# for municipality, (x, y) in municipalities.items():
#     plt.plot(x, y, 'ko')
#     plt.text(x, y, municipality, fontsize=9, ha='right')

# # Set title and show the plot
# plt.title(f"Shortest Path from {start_node} to {end_node}")
# plt.show()

# Set the figure size for the graph (maximized to full screen)
plt.figure(figsize=(18, 18))  # Maximized graph to full screen

# Plot all edges in blue
for node, neighbors in G.items():
    if node in C:
        x, y = C[node]
        for neighbor in neighbors:
            if neighbor in C:
                nx, ny = C[neighbor]
                plt.plot([x, nx], [y, ny], 'b-', alpha=0.5)  # Blue edges

# Plot all nodes as small blue dots
for node, (x, y) in C.items():
    plt.plot(x, y, 'bo', markersize=2)  # Small blue dots for nodes

# Plot the starting and ending nodes as larger red dots
if start_node and start_node in C:
    start_x, start_y = C[start_node]
    plt.plot(start_x, start_y, 'ro', markersize=8)  # Larger red dot for the start node

if end_node and end_node in C:
    end_x, end_y = C[end_node]
    plt.plot(end_x, end_y, 'ro', markersize=8)  # Larger red dot for the end node

# Plot the found path in red
if path:
    for i in range(len(path) - 1):
        x1, y1 = C[path[i]]
        x2, y2 = C[path[i + 1]]
        plt.plot([x1, x2], [y1, y2], 'r-', linewidth=3)  # Red path

# Plot the municipality names in black with small font, white halo, and thin black text
for municipality, (x, y) in municipalities.items():
    plt.plot(x, y, 'ko')  # Black dots for municipalities
    
    # Plot white text as a halo with offsets
    for dx, dy in [(-0.1, 0), (0.1, 0), (0, -0.1), (0, 0.1), (-0.1, -0.1), (0.1, 0.1), (-0.1, 0.1), (0.1, -0.1)]:
        plt.text(x + dx, y + dy, municipality, fontsize=7, ha='center', color='white', weight='bold')

    # Plot black text over the white halo
    plt.text(x, y, municipality, fontsize=7, ha='center', color='black', weight='light')

# Set the aspect ratio of the axes to be equal
plt.gca().set_aspect('equal', adjustable='box')  # Equal aspect ratio for X and Y axes

# Set the title and display the graph
plt.title(f"Shortest Path from {start_node_name} to {end_node_name}")
plt.show()

# Dijkstra's algorithm
p, d = SP.dijkstra(start_node, end_node)
print(f"Shortest path from {start_node} to 2: {p} with distance {d}")

# Belman-Ford's algorithm
p, d = SP.bellman_ford(start_node, end_node)
print(f"Shortest path from {start_node} to 2: {p} with distance {d}")

# Minimum spanning tree (Prim or Borůvka)
mst, weight = SP.prim()  # Prim's algorithm
print("Prim's MST:", mst, "with weight:", weight)

mst_b, weight_b = SP.boruvka()  # Borůvka's algorithm
print("Borůvka's MST:", mst_b, "with weight:", weight_b)

# # Plot the graph
# plt.figure(figsize=(12, 12))

# # Plot the graph edges
# for node, neighbors in G.items():
#     if node in C:
#         x, y = C[node]
#         for neighbor in neighbors:
#             if neighbor in C:
#                 nx, ny = C[neighbor]
#                 plt.plot([x, nx], [y, ny], 'b-', alpha=0.5)

# # Plot the municipalities
# for municipality, (x, y) in municipalities.items():
#     plt.plot(x, y, 'ro')
#     plt.text(x, y, municipality, fontsize=9, ha='right')

# SP.plot_path(path, C)
# SP.plot_mst(C, mst)

# plt.title("Graph Representation of the Road Network with Municipalities")
# plt.show()
