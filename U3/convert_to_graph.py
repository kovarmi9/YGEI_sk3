from geopandas import geopandas as gpd
from matplotlib import pyplot as plt

# Load the road network from the GeoPackage
road_network = gpd.read_file('data/roads.gpkg')

# Create a figure for plotting
plt.figure(figsize=(10, 10))

# Plot the road network geometries as lines
road_network.plot(color='blue')

# Add a title and display the plot
plt.title("Road Network")
plt.show()

# Create empty structures for the graph and coordinates
G = {}
C = {}

# Counter for node IDs
node_counter = 1

# Mapping from coordinates to node ID
coordinates_to_node_id = {}

# Iterate over all road segments
for line in road_network.geometry:
    if line.geom_type == 'MultiLineString':
        for part in line.geoms:
            coords = list(part.coords)
            start_point = coords[0]
            end_point = coords[-1]
            
            # Process start point if it's a new point
            if start_point not in coordinates_to_node_id:
                C[node_counter] = [start_point[0], start_point[1]]  # Store coordinates with node ID
                G[node_counter] = set()  # Initialize an empty set for neighbors
                coordinates_to_node_id[start_point] = node_counter  # Map coordinates to node ID
                node_counter += 1  # Increment node ID

            # Process end point if it's a new point
            if end_point not in coordinates_to_node_id:
                C[node_counter] = [end_point[0], end_point[1]]  # Store coordinates with node ID
                G[node_counter] = set()  # Initialize an empty set for neighbors
                coordinates_to_node_id[end_point] = node_counter  # Map coordinates to node ID
                node_counter += 1  # Increment node ID

            # Retrieve node IDs using the mapping
            start_id = coordinates_to_node_id[start_point]
            end_id = coordinates_to_node_id[end_point]

            # Add edges to structure G (using numerical node IDs)
            G[start_id].add(end_id)
            G[end_id].add(start_id)

    else:
        print(f"Error: Unknown geometry type: {line.geom_type}")

# Print graph and coordinates
print("\nG=")
print(G)
print("\nC=")
print(C)

# Save the graph in simple TXT format (node connections only)
txt_file = 'data/graph.txt'
with open(txt_file, 'w') as f:
    for node, neighbors in G.items():
        for neighbor in neighbors:
            f.write(f"{node} {neighbor}\n")

# Save the graph with coordinates and edge weights in TXT format
weighted_txt_file = 'data/weighted_graph.txt'
with open(weighted_txt_file, 'w') as f:
    for node, neighbors in G.items():
        for neighbor in neighbors:
            # Retrieve coordinates for both nodes
            start_x, start_y = C[node]
            end_x, end_y = C[neighbor]
            # Write edge with coordinates and weight 1
            f.write(f"{start_x} {start_y} {end_x} {end_y} 1\n")

# Create a figure for plotting the graph
plt.figure(figsize=(10, 10))

# Plotting edges and nodes
for node, neighbors in G.items():
    x, y = C[node]
    for neighbor in neighbors:
        nx, ny = C[neighbor]
        plt.plot([x, nx], [y, ny], 'b-', alpha=0.5)

    plt.plot(x, y, 'ro')

plt.title("Graph")
plt.show()