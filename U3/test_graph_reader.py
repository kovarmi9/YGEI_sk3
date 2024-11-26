import matplotlib.pyplot as plt
# Importing the function from graph_reader.py
from graph_reader import read_graph, read_nodes_names  # type: ignore

# Path to the graph file
file = './U3/data/graph_uncosted.txt'

# Read the graph from the file
G, C = read_graph(file)

# Printing the graph
print(G)
print(C)

# Path to the municipalities data file
municipalities_file = './U3/data/municipalities_nearest_nodes.txt'

# Read the municipalities using the dedicated function
municipalities = read_nodes_names(municipalities_file)

# Printing the municipalities
print("Municipalities:", municipalities)

# Plot the graph with edges and municipalities as red dots
plt.figure(figsize=(10, 10))

# Plot the graph edges
for node, neighbors in G.items():
    # Check if coordinates exist for the current node
    if node in C:
        x, y = C[node]
        for neighbor in neighbors:
            # Check if coordinates exist for the neighbor
            if neighbor in C:
                nx, ny = C[neighbor]
                plt.plot([x, nx], [y, ny], 'b-', alpha=0.5)  # Plot edges

# Plot the municipalities as red dots
for municipality, (x, y) in municipalities.items():
    plt.plot(x, y, 'ro')

# Title and labels
plt.title("Graph Representation of the Road Network with Municipalities")

# Show the plot
plt.show()