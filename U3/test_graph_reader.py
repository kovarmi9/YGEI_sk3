# Importing the function from graph_reader.py
from graph_reader import read_graph  # type: ignore

# Path to the file (absolute path example) if some subfolder begins with number 'r' is important
file = r'C:\Users\kovar\Desktop\Soubory\1.semestr\GEI\YGEI_sk3\U3\data\bayer_graph.txt'

# Relative path to the file in the 'data' subfolder (relative path example)
file = './U3/data/bayer_graph.txt'

# Check the current directory:
# If you have opened 'YGEI_sk3' in VS Code your current directory will be 'YGEI_sk3'
# If you opened just the 'U3' directory your current directory will be 'U3'
# Make sure that the file path corresponds to the directory you are currently in
# For example, if you're in 'YGEI_sk3', use './U3/data/bayer_graph.txt'

# Read the graph from the file
G = read_graph(file)

# Printing the graph
print(G)
