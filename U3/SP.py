from queue import PriorityQueue
from math import inf

class SP:
    def shortest_path(self, G, u, v):
        if self._has_negative_edges(G):
            p, d, pom = self.belmanFord(G, u, v)
            if pom:
                p, d = self._dijkstra(G, u, v)
        else:
            p, d = self.dijkstra(G, u, v)

        return p, d

    def dijkstra(self, G, u, v):
        n = len(G)
        P = [-1] * n
        D = [inf] * n
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
                if D[neighbor] > D[current_node] + weight:
                    D[neighbor] = D[current_node] + weight
                    P[neighbor] = current_node
                    PQ.put((D[neighbor], neighbor))
        
        return P, D[v]
    
    def belmanFord(self,G, source, target):
        # Initialize distances and predecessors
        n = len(G)
        d = [float('inf')] * (n + 1)
        p = [-1] * (n + 1)
        d[source] = 0

        # Relax all edges |V|-1 times
        for _ in range(n - 1):
            for u in G:  # for each vertex
                for v, weight in G[u].items():  # for each edge
                    if d[u] != float('inf') and d[u] + weight < d[v]:
                        d[v] = d[u] + weight
                        p[v] = u

        # Check for negative cycles
        for u in G:
            for v, weight in G[u].items():
                if d[u] != float('inf') and d[u] + weight < d[v]:
                    P = [0]
                    d = 0
                    print("Graph contains negative cycle")
                    return P, d,True
        
        # Return the shortest distance and the path
        return p, d[target] , False
    
    
    def _has_negative_edges(_self,G):
        # Iterate through all vertices and their edges
        for vertex in G:
            for neighbor, weight in G[vertex].items():
                # Check if any edge weight is negative
                if weight < 0:
                    return True
        return False
    
    def _dijkstra(self, G, u, v):
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
                    # Mark the vertex as visited
                    V[u] = 1
        
        return P, D[v]