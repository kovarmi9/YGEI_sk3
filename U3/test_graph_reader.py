import matplotlib.pyplot as plt
# Importing the function from graph_reader.py
from graph_reader import read_graph  # type: ignore

# Path to the graph file
file = './U3/data/graph_unweighted.txt'

# Read the graph from the file
G, C = read_graph(file)

# Printing the graph
print(G)
print(C)

# Read the municipalities data from the text file
municipalities_file = './U3/data/municipalities_nearest_nodes.txt'

municipalities = {}
try:
    with open(municipalities_file, 'r', encoding='utf-8') as f:
        for line in f:
            # Split the line into name and coordinates
            parts = line.strip().split(',')
            if len(parts) == 3:  # Check if line has the expected format
                name, x, y = parts
                try:
                    municipalities[name] = (float(x), float(y))
                except ValueError:
                    print(f"Skipping invalid line (could not convert coordinates): {line}")
            else:
                print(f"Skipping malformed line: {line}")
except FileNotFoundError:
    print(f"Error: File '{municipalities_file}' not found.")
except UnicodeDecodeError as e:
    print(f"Error reading file '{municipalities_file}': {e}")

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
