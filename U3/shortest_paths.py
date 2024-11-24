from queue import PriorityQueue
from math import inf

class ShortestPath:
    def shortest_path(self, G: dict, u: int, v: int) -> tuple[list, float]:
        """
        Find the shortest path between two nodes in a graph.
        
        Parameters:
            G (dict): Adjacency list representation of the graph
            u (int): Starting node
            v (int): Target node
        
        Returns:
            tuple[list, float]: Parent array and distance to target
        """
        # If the start and end are the same, return an empty path and distance 0
        if u == v:
            print("begin and end are the same")
            return [-1], 0

        # If the graph has negative edges, use Bellman-Ford, otherwise use Dijkstra
        if self._has_negative_edges(G):
            p, d = self.bellman_ford(G, u, v)
        else:
            p, d = self.dijkstra(G, u, v)
        return p, d

    def dijkstra(self, G, start, target):
        """
        Dijkstra's algorithm to find the shortest path in a graph.
        
        Parameters:
            G (list of dict): Adjacency list representation of the graph.
            start (int): Starting node.
            target (int): Target node.
        
        Returns:
            tuple: 
                - P (list): Parent array representing the shortest path tree.
                - D[target] (float): Distance to the target node.
        """
        # If the start and end are the same, return an empty path and distance 0
        if start == target:
            print("begin and end are the same")
            return [-1], 0
        
        n = len(G)  # Number of nodes in the graph
        P = [-1] * (n+1)  # Parent array to reconstruct paths
        D = [inf] * (n+1)  # Distance array, initialized to infinity
        PQ = PriorityQueue()  # Priority queue to pick the next minimum distance node
        
        PQ.put((0, start))  # Add the starting node with distance 0
        D[start] = 0  # Distance to the start node is 0
        
        while not PQ.empty():
            current_distance, current_node = PQ.get()
            
            # If we've already found a shorter path, skip processing this node
            if current_distance > D[current_node]:
                continue
            
            # If the target node is reached terminate early
            if current_node == target:
                break
            
            # Explore neighbors of the current node
            for neighbor, weight in G[current_node].items():
                if D[neighbor] > D[current_node] + weight:
                    D[neighbor] = D[current_node] + weight
                    P[neighbor] = current_node
                    PQ.put((D[neighbor], neighbor))
        
        return P, D[target]
    
    def bellman_ford(self, G: dict, start: int, target: int) -> tuple[list, float]:
        """
        Bellman-Ford algorithm to find shortest path in a graph with negative edges.
        
        Parameters:
            G (dict): Adjacency list representation of the graph
            source (int): Starting node
            target (int): Target node
        
        Returns:
            tuple[list, float]: Parent array and distance to target
        
        Raises:
            ValueError: If a negative cycle is detected
        """
        # If the start and end are the same, return an empty path and distance 0
        if start == target:
            print("begin and end are the same")
            return [-1], 0
        
        n = len(G) # Number of nodes in the graph
        d = [float('inf')] * (n + 1) # Distance array, initialized to infinity
        p = [-1] * (n + 1) # Parent array to reconstruct paths
        d[start] = 0 # Distance to the start node is 0

        # Relax all edges |V|-1 times
        for _ in range(n - 1): # the variable is not used, but it is the number of edges
            for u in G:  # for each vertex
                for v, weight in G[u].items():  # for each edge
                    # If the distance to the current node is not infinity and the distance to the neighbor is greater than the distance to the current node plus the weight of the edge, update the distance and parent
                    if d[u] != float('inf') and d[u] + weight < d[v]:  
                        d[v] = d[u] + weight
                        p[v] = u

        # Check for negative cycles
        for u in G:
            for v, weight in G[u].items():
                # If the distance to the current node is not infinity and the distance to the neighbor is greater than the distance to the current node plus the weight of the edge, raise an error
                if d[u] != float('inf') and d[u] + weight < d[v]:
                    raise ValueError("Negative cycle detected in the graph")

        return p, d[target]
    
    
    def _has_negative_edges(self, G: dict) -> bool:
        """
        Check if the graph contains any negative edges.
        
        Parameters:
            G (dict): Adjacency list representation of the graph
        
        Returns:
            bool: True if negative edges exist, False otherwise
        """
        # Iterate through all vertices and their edges
        for vertex in G:
            for neighbor, weight in G[vertex].items():
                # Check if any edge weight is negative
                if weight < 0:
                    return True
        return False