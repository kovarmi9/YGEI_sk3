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