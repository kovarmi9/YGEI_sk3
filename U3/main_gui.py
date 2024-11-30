import tkinter as tk
from tkinter import ttk
from matplotlib import pyplot as plt
from graph_reader import read_graph, read_nodes_names  # Import functions to load graph and node names
from graph_path_finder import GraphPathFinder  # Class for pathfinding operations

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

# Create the tkinter window
root = tk.Tk()
root.title("Select Start and End Municipality")

# Add labels for the dropdown menus
tk.Label(root, text="Select Start Municipality:").grid(row=0, column=0, padx=10, pady=10)
tk.Label(root, text="Select End Municipality:").grid(row=1, column=0, padx=10, pady=10)

# Create comboboxes for selecting start and end municipalities sorted by alphabet
start_combobox = ttk.Combobox(root, values=sorted(list(municipality_to_node.keys())))
end_combobox = ttk.Combobox(root, values=sorted(list(municipality_to_node.keys())))

# Place comboboxes in the window
start_combobox.grid(row=0, column=1, padx=10, pady=10)
end_combobox.grid(row=1, column=1, padx=10, pady=10)

# Function to handle the "Show Path" button click
def on_button_click():

    # Get the selected municipalities
    start_node_name = start_combobox.get()
    end_node_name = end_combobox.get()

    # Get the corresponding nodes for the selected municipalities
    start_node = municipality_to_node.get(start_node_name, None)
    end_node = municipality_to_node.get(end_node_name, None)

    # Check if both start and end nodes are valid
    if start_node is None:
        print(f"Start node '{start_node_name}' not found.")
    if end_node is None:
        print(f"End node '{end_node_name}' not found.")
    if start_node is not None and end_node is not None:
        print(f"Start node '{start_node_name}' corresponds to node {start_node}; End node '{end_node_name}' corresponds to node {end_node}")

    # Create a GraphPathFinder instance
    SP = GraphPathFinder(G)

    # BFS and print the result
    P = SP.BFS(start_node)
    print(f"BFS Path from Node {start_node}: {P}")

    # DFS and print the result
    P = SP.DFS(start_node)
    print(f"DFS Path from Node {start_node}: {P}")

    # Find all shortest paths
    all_paths = SP.all_shortest_paths()
    print("All shortest paths:", all_paths)

    # Find the shortest path from start to end node using the appropriate algorithm
    P, dmin = SP.shortest_cost_path(start_node, end_node)

    # Reconstruct the specific path from start to end
    path = SP.rec_path(start_node, end_node, P)
    print(f"Path from {start_node} to {end_node}: {path} with weight {dmin}")

    # Set the figure size for the plot
    plt.figure(1, figsize=(10, 10))

    # Plot the graph
    SP.plot_graph(C)

    # Plot the start and end nodes as larger red dots
    SP.plot_red_nodes({start_node, end_node}, C)

    # If a path exists, plot the shortest path
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

# Create a button to show the path
button = tk.Button(root, text="Show Path", command=on_button_click)
button.grid(row=2, column=0, columnspan=2, pady=10)

# Start the Tkinter event loop to listen for user interactions
root.mainloop()
