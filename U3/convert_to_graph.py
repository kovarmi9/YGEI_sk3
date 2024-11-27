import geopandas as gpd
from shapely.geometry import Point, LineString, MultiLineString
from matplotlib import pyplot as plt

# File paths to GeoPackage files
roads_path = r"data/roads.gpkg"
municipalities_path = r"data/municipalities.gpkg"

# Load roads and municipalities data
roads = gpd.read_file(roads_path)
municipalities = gpd.read_file(municipalities_path)

# Plot the road network and municipalities
plt.figure(figsize=(10, 10))
roads.plot(color='blue', linewidth=0.5)
municipalities.plot(ax=plt.gca(), color='red', markersize=10)  # Plot municipalities in red
plt.title("Road Network with Municipalities")
plt.show()

def calculate_curvature(row):
    """
    Calculate curvature as the ratio of total length to straight-line distance.
    """
    geometry = row.geometry
    if geometry.is_empty:
        return None  # No curvature for empty geometry
    # Calculate total length (sum of lengths of all LineStrings)
    total_length = sum([line.length for line in geometry.geoms])
    # Calculate straight-line distance between the first point and last point
    start_point = list(geometry.geoms[0].coords)[0]  # First point of the first LineString
    end_point = list(geometry.geoms[-1].coords)[-1]  # Last point of the last LineString
    straight_distance = ((end_point[0] - start_point[0])**2 + (end_point[1] - start_point[1])**2)**0.5
    if straight_distance == 0:
        return float('inf')  # Return infinity if straight distance is zero
    # Return the curvature (ratio of total length to straight-line distance)
    return total_length / straight_distance

def create_graph_file(roads, cost_column, output_file, default_cost=None):
    """
    Create a graph file with costed or uncosted edges.
    """
    with open(output_file, 'w') as file:
        for _, row in roads.iterrows():
            geometry = row.geometry
            if default_cost is not None:
                cost = default_cost
            else:
                cost = row[cost_column]
            # Check if the geometry is a MultiLineString
            if isinstance(geometry, MultiLineString):
                # For MultiLineString, use the start point of the first LineString and the end point of the last LineString
                start_coords = list(geometry.geoms[0].coords)[0]  # First point of the first LineString
                end_coords = list(geometry.geoms[-1].coords)[-1]  # Last point of the last LineString
                file.write(f"{start_coords[0]} {start_coords[1]} {end_coords[0]} {end_coords[1]} {cost}\n")
            elif isinstance(geometry, LineString):
                # For LineString, create edges between every two consecutive points
                coords = list(geometry.coords)
                for i in range(len(coords) - 1):
                    start = coords[i]
                    end = coords[i + 1]
                    file.write(f"{start[0]} {start[1]} {end[0]} {end[1]} {cost}\n")

# Map road classes (speed limits based on road classification)
speed_mapping = {1: 130, 2: 110, 3: 90, 4: 70, 5: 50}

# Add calculated columns
roads['length'] = roads['geometry'].length
roads['design_speed'] = roads['TRIDA'].map(speed_mapping)
roads['curvature'] = roads.apply(calculate_curvature, axis=1)
roads['length_cost'] = 1 / roads['length']
roads['speed_cost'] = 1 / roads['design_speed']

# Function to extract nodes (start and end points) from MultiLineString
def extract_nodes_from_multilinestring(geometry):
    """
    Extracts the start and end points (nodes) of a MultiLineString geometry.
    """
    nodes = []
    if isinstance(geometry, MultiLineString):
        # Extract start and end points of each LineString within the MultiLineString
        for line in geometry.geoms:
            start_point = Point(line.coords[0])  # Start of the LineString
            end_point = Point(line.coords[-1])  # End of the LineString
            nodes.append(start_point)
            nodes.append(end_point)
    return nodes

# Initialize an empty list to store all the road nodes (start and end points)
all_nodes = []

# Loop through each road geometry in the roads dataset
for geometry in roads.geometry:
    # Check if the geometry is a MultiLineString (a road with multiple segments)
    if isinstance(geometry, MultiLineString):
        # Loop through each segment (LineString) within the MultiLineString
        for line in geometry.geoms:
            # Get the starting point of the segment (the first coordinate)
            start_point = Point(line.coords[0])  # First point of the segment
            # Get the ending point of the segment (the last coordinate)
            end_point = Point(line.coords[-1])   # Last point of the segment
            # Add both points (start and end) to the list of nodes
            all_nodes.append(start_point)
            all_nodes.append(end_point)

# Convert the list of nodes (start and end points) into a GeoSeries for easier handling with GeoPandas
nodes_gdf = gpd.GeoSeries(all_nodes, crs=roads.crs)

def nearest_node_to_point(municipality_point, nodes_gdf):
    """
    Find the nearest road node to the given municipality point.
    """
    distances = nodes_gdf.distance(municipality_point)
    nearest_node = nodes_gdf.loc[distances.idxmin()]
    return nearest_node

# Compute nearest node for each municipality and create a new GeoDataFrame with those points
def compute_nearest_node(row, nodes_gdf):
    """
    Computes the nearest node for a given municipality point.
    """
    return nearest_node_to_point(row.geometry, nodes_gdf)

# Store the nearest node coordinates for each municipality
municipalities['nearest_node_coords'] = municipalities.apply(compute_nearest_node, axis=1, nodes_gdf=nodes_gdf)

# Save municipalities with nearest node information to a text file
output_file_path = 'data/municipalities_nearest_nodes.txt'
with open(output_file_path, 'w') as file:
    for _, row in municipalities.iterrows():
        name = row['NAZ_OBEC']  # Column for municipality name
        nearest_node = row['nearest_node_coords']
        file.write(f"{name},{nearest_node.x},{nearest_node.y}\n")

# Export of road graphs
create_graph_file(roads, 'length_cost', 'data/graph_length_cost.txt')  # Cost based on length
create_graph_file(roads, 'curvature', 'data/graph_curvature.txt')      # Cost based on curvature
create_graph_file(roads, 'speed_cost', 'data/graph_speed_cost.txt')    # Cost based on speed
create_graph_file(roads, None, 'data/graph_uncosted.txt', default_cost=1)  # Unweighted graph with cost = 1

# Output summary
print(roads[['geometry', 'curvature', 'length_cost', 'speed_cost']].head())
print("Graph files with cost-based edges have been successfully created.")
print("Nearest nodes of municipalities have been successfully written to the text file.")