import geopandas as gpd
from matplotlib import pyplot as plt

# File path to GeoPackage
file_path = r"data/roads_pk.gpkg"

# Load road data
roads = gpd.read_file(file_path)

# Plot the road network
plt.figure(figsize=(10, 10))
roads.plot(color='blue', linewidth=0.5)
plt.title("Road Network")
plt.xlabel("Longitude")
plt.ylabel("Latitude")
plt.show()

def calculate_curvature(row):
    """
    Calculate curvature as the ratio of total length to straight-line distance.
    """
    geometry = row.geometry
    if geometry.is_empty:
        return None  # No curvature for empty geometry
    total_length = geometry.length
    # Calculate straight-line distance between start and end points
    start_point = list(geometry.geoms[0].coords)[0]
    end_point = list(geometry.geoms[-1].coords)[-1]
    straight_distance = ((end_point[0] - start_point[0])**2 + (end_point[1] - start_point[1])**2)**0.5
    if straight_distance == 0:  # Avoid division by zero
        return 0
    return total_length / straight_distance

def create_graph_file(roads, cost_column, output_file, default_cost=None):
    """
    Create a graph file with weighted edges.
    If a default_cost is provided, it is used as the weight for all edges.
    """
    # Open the output file for writing
    with open(output_file, 'w') as file:
        # Iterate through each row in the 'roads' dataset
        for _, row in roads.iterrows():
            # Get the geometry of the current row
            geometry = row.geometry
            # Determine the edge cost: use default_cost if provided, otherwise use the cost column
            if default_cost is not None:
                cost = default_cost
            else:
                cost = row[cost_column]
            # Iterate through each line (LineString) in the MultiLineString geometry
            for linestring in geometry.geoms:
                # Get the list of coordinates in the current line
                coords = list(linestring.coords)
                # Iterate through pairs of consecutive points and write each edge
                for i in range(len(coords) - 1):
                    start = coords[i]  # Starting point of the edge
                    end = coords[i + 1]  # Ending point of the edge
                    # Write the edge to the file in the format: x1 y1 x2 y2 cost
                    file.write(f"{start[0]} {start[1]} {end[0]} {end[1]} {cost}\n")

# Map road classes
speed_mapping = {1: 130, 2: 90, 3: 80, 4: 70, 5: 50}

# Add calculated columns
roads['length'] = roads['geometry'].length
roads['design_speed'] = roads['TRIDA'].map(speed_mapping)
roads['curvature'] = roads.apply(calculate_curvature, axis=1)
roads['length_cost'] = 1 / roads['length']
roads['speed_cost'] = 1 / roads['design_speed']

# Select relevant columns for the graph
roads_for_graph = roads[['geometry', 'curvature', 'length_cost', 'speed_cost']]

# Export of graphs
create_graph_file(roads, 'length_cost', 'data/graph_length_cost.txt')  # Cost based on length
create_graph_file(roads, 'curvature', 'data/graph_curvature.txt')      # Cost based on curvature
create_graph_file(roads, 'speed_cost', 'data/graph_speed_cost.txt')    # Cost based on speed
create_graph_file(roads, None, 'data/graph_unweighted.txt', default_cost=1)  # Unweighted graph with cost = 1

# Output summary
print(roads[['geometry', 'curvature', 'length_cost', 'speed_cost']].head())
print("Graph files with cost-based edges have been successfully created.")
