from math import inf
from queue import PriorityQueue
from matplotlib import pyplot as plt

# Graph for Dijkstra
G = {
    1 : {2:8, 3:4, 5:2},
    2 : {1:8, 3:5, 4:2, 7:6, 8:7},
    3 : {1:4, 2:5, 6:3, 7:4},
    4 : {2:2, 9:3},
    5 : {1:2, 6:5},
    6 : {3:3, 5:5, 7:5, 8:7, 9:10},
    7 : {2:6, 3:4, 6:5, 8:3},
    8 : {2:7, 6:7, 7:3, 9:1},
    9 : {4:3, 6:10, 8:1}
}

# Coordinates for plotting
C = {
    1 : [95, 322],
    2 : [272, 331],
    3 : [173, 298],
    4 : [361, 299],
    5 : [82, 242],
    6 : [163, 211],
    7 : [244, 234],
    8 : [333, 225],
    9 : [412, 196]
}

"""Read data from file"""
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
G, C = read_graph(file)

# Printing the graph
print(G)
print(C)
"""Functions"""

def rec(u, v, P):
    path = []
    
    # Path shortening
    while v != u and v != -1:
        path.append(v)
        v = P[v]
        
    path.append(v)
    if v != u:
        print('Incorrect path')
    return path

def dijkstra(G, u, v):
    # Input data structures
    n = len(G)
    P = [-1] * (n + 1)
    D = [inf] * (n + 1)
    PQ = PriorityQueue()
    
    # Starting node, add to PQ
    PQ.put((0, u))
    D[u] = 0
    
    # Until PQ is empty
    while not PQ.empty():
        
        # Remove node u with the lowest D[u] estimation
        du, u = PQ.get()
        
        # Iterate through neighbours
        for v, wuv in G[u].items():
        
            # Edge relaxation: path to v through u is better
            if D[v] > D[u] + wuv:
                
                # Actualize D[v] estimation
                D[v] = D[u] + wuv
                
                # Store v predecessor (u)
                P[v] = u
                
                # Add v to PQ
                PQ.put((D[v], v))
                
    return P, D[v]

'''Print graph according to Filip'''

def PlotGraph(G, C):
    # Plot the nodes
    plt.figure(figsize=(8, 6))
    for node, (x, y) in C.items():
        plt.scatter(x, y, color='red')
        plt.text(x+5, y, str(node), fontsize=12, ha='left')

    # Plot the edges
    for node, neighbors in G.items():
        x_start, y_start = C[node]
        for neighbor in neighbors:
            x_end, y_end = C[neighbor]
            plt.plot([x_start, x_end], [y_start, y_end], 'k-', lw=1)  # Line between nodes

    plt.xlabel("X-axis")
    plt.ylabel("Y-axis")
    plt.grid(True)
    pass    

def PlotPath(path, C):
    for node in range(len(path)-1):
        x_start, y_start = C[path[node]]
        x_end, y_end = C[path[node+1]]
        plt.plot([x_start, x_end], [y_start, y_end], 'r-', lw=1)

    pass

'''Results'''

# Dijkstra
P, dmin = dijkstra(G, 1, 9)
    
# Backward path reconstruction
path = rec(1, 9, P)
print(path, dmin)

# Plot the graph and the path
PlotGraph(G, C)
PlotPath(path[::-1], C) # Reverse the path to plot from start to end
plt.show()