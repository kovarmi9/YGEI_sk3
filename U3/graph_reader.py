from collections import defaultdict
from numpy import unique

def read_graph(file_name):
    # Function for loading edges
    def loadEdges(file_name):
        PS = []  # List of starting points
        PE = []  # List of ending points
        W = []   # List of weights
        with open(file_name) as f:
            for line in f:
                # Split the line into x1, y1, x2, y2, w
                x1, y1, x2, y2, w = line.split()
                
                # Add the points and weight to the lists
                PS.append((float(x1), float(y1)))
                PE.append((float(x2), float(y2)))
                W.append(float(w))
        return PS, PE, W

    # Function to create a map of points to IDs
    def pointsToIDs(P):
        D = {}
        for i in range(len(P)):
            D[(P[i][0], P[i][1])] = i + 1  # Start IDs from 1
        return D

    # Function to convert edges to a graph
    def edgesToGraph(D, PS, PE, W):
        G = defaultdict(dict)
        for i in range(len(PS)):
            G[D[PS[i]]][D[PE[i]]] = W[i]
            G[D[PE[i]]][D[PS[i]]] = W[i]
        return G
    
    # Load edges from the file
    PS, PE, W = loadEdges(file_name)

    # Merge lists of points and remove duplicates
    PSE = PS + PE
    PSE = unique(PSE, axis=0).tolist()

    # Create a map of points to IDs
    D = pointsToIDs(PSE)
    
    # Create the graph from edges
    G = edgesToGraph(D, PS, PE, W)
    
    # Create coordinates dictionary
    C = {D[(x, y)]: [x, y] for x, y in PSE}
    
    return G, C  # Return the graph and coordinates

def read_nodes_names(file_name):
    nodes = {}  # Create an empty dictionary to store node names and coordinates

    # Open the file in read mode with UTF-8 encoding
    with open(file_name, 'r', encoding='utf-8') as f:
        for line in f:
            # Remove extra spaces at the beginning and end, then split the line by spaces
            parts = line.strip().split()

            # Check if the line contains exactly 3 parts: name, x, and y
            if len(parts) == 3:
                name, x, y = parts

                # Try to convert the x and y values to float
                try:
                    nodes[name] = (float(x), float(y))  # Store the name and coordinates in the dictionary
                except ValueError:
                    # If x or y cannot be converted to a float, skip this line
                    continue
            # If the line does not have exactly 3 parts, skip it
            else:
                continue

    return nodes  # Return the dictionary of nodes

def node_name_to_node(node_name, node_names, C, tolerance=1e-6):
    """
    Function to convert a node name to its corresponding node number based on coordinates.
    
    :param node_name: The name of the node (string).
    :param node_names: Dictionary of node names and their coordinates.
    :param C: Dictionary of node numbers and their coordinates.
    :param tolerance: A tolerance value for comparing coordinates to account for small precision differences.
    
    :return: Node number (integer) or None if no match is found.
    """
    # Check if the node name exists in the node_names dictionary
    if node_name in node_names:
        node_coords = node_names[node_name]
        print(f"Looking for {node_name} with coordinates {node_coords}")
        
        # Iterate through the nodes in C and find the matching coordinates
        for node, coords in C.items():
            print(f"Checking node {node} with coordinates {coords}")
            
            # Compare the coordinates with a tolerance to handle small rounding errors
            if abs(coords[0] - node_coords[0]) < tolerance and abs(coords[1] - node_coords[1]) < tolerance:
                return node
    
    return None  # Return None if no matching node is found