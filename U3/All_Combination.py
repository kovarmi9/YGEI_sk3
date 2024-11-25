from math import inf
from queue import PriorityQueue

from matplotlib import pyplot as plt
from shortest_path import ShortestPath
from mst import MST

G = {
    1 : {2:8, 3:4, 5:2},
    2 : {1:8, 3:5, 4:2, 7:6, 8:7},
    3 : {1:4, 2:5, 6:3, 7:4},
    4 : {2:2, 9:3},
    5 : {1:2, 6:5},
    6 : {3:3, 5:5, 7:5, 8:7, 9:10},
    7 : {2:6, 3:4, 6:5, 8:10},
    8 : {2:7, 6:7, 7:10, 9:1},
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
    
    while not PQ.empty():
        du, u = PQ.get()
        
        # Optional: Early stopping if we reached target
        if u == v:
            break
            
        # Skip if we found a better path already
        if du > D[u]:
            continue
            
        # Iterate through neighbours
        for neighbor, weight in G[u].items():
            # Edge relaxation: path to neighbor through u is better
            if D[neighbor] > D[u] + weight:
                D[neighbor] = D[u] + weight
                P[neighbor] = u
                PQ.put((D[neighbor], neighbor))
                
    return P, D[v] # Return predecessor and distance to target

#P, dmin = dijkstra(G, 1, 9)

#path = rec(1,2,P)
#print(path,dmin)

def allPaths(G):
    paths = {}
    keys = list(G.keys())
    for i in range(len(keys)):
        for j in range(i + 1, len(keys)):
            P, dmin = dijkstra(G, keys[i], keys[j])
            path = rec(keys[i], keys[j], P)
            paths[keys[i], keys[j]] = (path, dmin)

    return paths


#GPF = GraphPathFinder()
SP = ShortestPath(G)

#P, dmin = GPF.shortest_cost_path(G, 1,7)

#print(dmin)

P = SP.BFS(1)
print(P)
P = SP.DFS(1)
print(P)

paths = SP.all_shortest_paths()
print(paths)

path = SP.rec_path(1,2,P)
print(path)

SP.plot_graph(C)
SP.plot_path(path,C)
plt.show()

p, d = SP.dijkstra(1,2)



T, w = SP.prim()
print(T,w)
T, w = SP.boruvka()
print(T,w)

SP.plot_mst(C,T)
plt.show()
