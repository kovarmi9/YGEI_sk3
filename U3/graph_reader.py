from collections import defaultdict
from numpy import unique

def read_graph(file_name):
    """
    Reads a graph from a file, generating an adjacency dictionary representation and a coordinates dictionary.

    Parameters:
        file_name (str): Path to the file containing graph edges. Each line in the file should follow the format:
                         x1 y1 x2 y2 w
                         where (x1, y1) and (x2, y2) are coordinates of edge endpoints, and w is the weight of the edge.

    Returns:
        A tuple containing:
            - G (dict): Adjacency dictionary representing the graph. 
                        Keys are node IDs, and values are dictionaries mapping neighboring nodes to edge weights.
            - C (dict): Coordinates dictionary mapping node IDs to their coordinates [x, y].
    """
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
        """
        Load edges from the file, separating starting points, ending points, and weights.

        Parameters:
            file_name (str): Path to the file containing graph edges.

        Returns:
            tuple: Three lists:
                - PS (list): Starting points as coordinate tuples [(x1, y1), ...].
                - PE (list): Ending points as coordinate tuples [(x2, y2), ...].
                - W (list): Weights of the edges [w1, w2, ...].
        """
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
    """
    Reads a file containing node names and their corresponding coordinates.

    Parameters:
        file_name (str): Path to the file containing node data. Each line should follow the format:
                         name, x, y
                         where `name` is the node name, and `x` and `y` are its coordinates.

    Returns:
        dict: A dictionary where keys are node names (str), and values are coordinate tuples (x, y).
    """
    nodes = {}  # Create an empty dictionary to store node names and coordinates

    # Open the file in read mode with UTF-8 encoding
    with open(file_name, 'r', encoding='utf-8') as f:
        for line in f:
            # Remove extra spaces at the beginning and end, then split the line by comma
            parts = line.strip().split(',')

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