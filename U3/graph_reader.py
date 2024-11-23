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
            D[(P[i][0], P[i][1])] = i
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
    PSE.insert(0, [1000000, 1000000])  # Adding a special point

    # Create a map of points to IDs
    D = pointsToIDs(PSE)
    
    # Create the graph from edges
    G = edgesToGraph(D, PS, PE, W)
    
    # Create coordinates dictionary
    C = {D[(x, y)]: [x, y] for x, y in PSE}
    
    return G, C  # Return the graph and coordinates