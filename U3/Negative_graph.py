from queue import PriorityQueue
from math import inf

G = {
    1 : {2:-8, 3:4, 5:2},
    2 : {1:-8, 3:5, 4:2, 7:6, 8:7},
    3 : {1:4, 2:5, 6:3, 7:4},
    4 : {2:2, 9:3},
    5 : {1:2, 6:5},
    6 : {3:3, 5:5, 7:5, 8:7, 9:10},
    7 : {2:6, 3:4, 6:5, 8:3},
    8 : {2:7, 6:7, 7:3, 9:1},
    9 : {4:3, 6:10, 8:1}
}

def dijkstra(G, u, v):
    n = len(G)
    P = [-1] * n
    D = [inf] * n
    V = [-1] * n
    PQ = PriorityQueue()
        
    PQ.put((0, u))
    D[u] = 0
        
    while not PQ.empty():
        du, current_node = PQ.get()
            
        if current_node == v:
            break
            
        if du > D[current_node]:
            continue
            
        for neighbor, weight in G[current_node].items():
            if (D[neighbor] > D[current_node] + weight) and (V[u] == -1):
                D[neighbor] = D[current_node] + weight
                P[neighbor] = current_node
                PQ.put((D[neighbor], neighbor))
                V[u] = 1
        
    return P, D[v]

P, dmin = dijkstra(G, 1, 2)
print(P, dmin)
