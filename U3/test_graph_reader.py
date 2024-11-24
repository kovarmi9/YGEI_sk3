import matplotlib.pyplot as plt
# Importing the function from graph_reader.py
from graph_reader import read_graph  # type: ignore

# Path to the file (absolute path example) if some subfolder begins with number 'r' is important
file = r'C:\Users\kovar\Desktop\Soubory\1.semestr\GEI\YGEI_sk3\U3\data\bayer_graph.txt'

# Relative path to the file in the 'data' subfolder (relative path example)
file = './U3/data/graph_unweighted.txt'

# Check the current directory:
# If you have opened 'YGEI_sk3' in VS Code your current directory will be 'YGEI_sk3'
# If you opened just the 'U3' directory your current directory will be 'U3'
# Make sure that the file path corresponds to the directory you are currently in
# For example, if you're in 'YGEI_sk3', use './U3/data/bayer_graph.txt'

# Read the graph from the file
G, C = read_graph(file)

# Printing the graph
print(G)
print(C)

# Plot the graph with edges and nodes
plt.figure(figsize=(10, 10))
for node, neighbors in G.items():
    # Check if coordinates exist for the current node
    if node in C:
        x, y = C[node]
        for neighbor in neighbors:
            # Check if coordinates exist for the neighbor
            if neighbor in C:
                nx, ny = C[neighbor]
                plt.plot([x, nx], [y, ny], 'b-', alpha=0.5)  # Plot edges

        plt.plot(x, y, 'ro')  # Plot nodes

plt.title("Graph Representation of the Road Network")
plt.xlabel("Longitude")
plt.ylabel("Latitude")
plt.show()