from math import inf
from queue import PriorityQueue

from matplotlib import pyplot as plt
from graph_path_finder import GraphPathFinder
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

#GPF = GraphPathFinder()
SP = GraphPathFinder(G)

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
