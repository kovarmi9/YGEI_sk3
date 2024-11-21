from geopandas import geopandas as gpd
from matplotlib import pyplot as plt

# Load the road network from the GeoPackage
road_network = gpd.read_file('data/roads.gpkg')

# Create a figure for plotting
plt.figure(figsize=(10, 10))

# Plot the road network geometries as lines
road_network.plot(ax=plt.gca(), color='blue', linewidth=0.5)

# Add a title and display the plot
plt.title("Road Network")
plt.show()

# Create empty structures for the graph and coordinates
G = {}
C = {}

# Iterate over all road segments
for line in road_network.geometry:
    if line.geom_type == 'MultiLineString':
        # For MultiLineString, take all parts (geometries)
        for part in line.geoms:
            coords = list(part.coords)
            start_point = coords[0]
            end_point = coords[-1]
            
            # Store node coordinates in structure C
            if start_point not in C:
                C[start_point] = start_point
            if end_point not in C:
                C[end_point] = end_point

            # Add edges to structure G (using set to eliminate duplicates)
            if start_point not in G:
                G[start_point] = set()
            if end_point not in G:
                G[end_point] = set()
            
            G[start_point].add(end_point)
            G[end_point].add(start_point)

    else:
        #  Print error message if the geometry type is not MultiLineString
        print(f"Error: Geometry type {line.geom_type} is not supported. Row: {line}")

