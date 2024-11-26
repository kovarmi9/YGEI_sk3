from queue import PriorityQueue
from math import inf

class ShortestPath:
    def __init__(self, G:dict):
        """
        Initialize the graph path finder with a given graph.

        Parameters:
            G (dict): Adjacency list representation of the graph where 
                      G[u] = {v: weight, ...} maps neighbors v of node u to their edge weights.
        """
        self.G = G

    def shortest_cost_path(self, start: int, target: int) -> tuple[list, float]:
        """
        Find the shortest path between two nodes in a graph, if you dont know data about the graph.
        
        Parameters:
            start (int): Starting node
            target (int): Target node
        
        Returns:
            tuple[list, float]: 
                - Parent array representing the shortest path tree.
                - Distance to the target node from the start node.
        """

        # check if the graph contains negative-weight edges
        if self._has_negative_edges():
            # use the Bellman-Ford algorithm if negative edges are present
            # bellman-Ford works even with negative weights and can detect negative weight cycles
            p, d = self.bellman_ford(start, target)
        else:
            # use Dijkstra's algorithm if all edge weights are non-negative
            # dijkstra's algorithm is more efficient for graphs with only non-negative weights
            p, d = self.dijkstra(start, target)

        # return the parent array and the shortest distance to the target node
        return p, d

    def dijkstra(self, start: int, target: int) -> tuple[list, float]:
        """
        Dijkstra's algorithm to find the shortest path in a graph with non-negative weights.

        Parameters:
            start (int): Starting node.
            target (int): Target node.

        Returns:
            tuple[list, float]: 
                - Parent array representing the shortest path tree.
                - Distance to the target node from the start node.
        """
        # if the start and end are the same, return an empty path and distance 0
        if start == target:
            print("begin and end are the same")
            return [-1], 0  # no path needed if start == target

        n = len(self.G)                 # number of nodes in the graph
        P = [-1] * (n + 1)              # parent array to store the path reconstruction
        D = [float('inf')] * (n + 1)    # distance array, initialized to infinity
        PQ = PriorityQueue()            # priority queue for processing nodes in order of distance

        # start from the given starting node
        PQ.put((0, start))      # add the start node with distance 0
        D[start] = 0            # the distance to the start node is 0

        # main loop: process each node
        while not PQ.empty():
            current_distance, current_node = PQ.get()  # get the node with the smallest distance
            
            # if we already found a shorter path to this node, skip further processing
            if current_distance > D[current_node]:
                continue
            
            # if we've reached the target node, we can stop early
            if current_node == target:
                break
            
            # explore neighbors of the current node
            for neighbor, weight in self.G[current_node].items():
                # relax the edge: check if a shorter path to 'neighbor' is found
                if D[neighbor] > D[current_node] + weight:
                    D[neighbor] = D[current_node] + weight  # update the distance
                    P[neighbor] = current_node              # set the current node as the parent
                    PQ.put((D[neighbor], neighbor))         # add the neighbor to the priority queue

        # return the parent array and the shortest distance to the target node
        return P, D[target]
    
    def bellman_ford(self, start: int, target: int)-> tuple[list, float]:
        """
        Dijkstra's algorithm to find the shortest path in a graph with non-negative weights.

        Parameters:
            start (int): Starting node.
            target (int): Target node.

        Returns:
            tuple[list, float]: 
                - Parent array representing the shortest path tree.
                - Distance to the target node from the start node.
        
        Raises:
            ValueError: If a negative cycle is detected
        """
        # if the start and end are the same, return an empty path and distance 0
        if start == target:
            print("begin and end are the same")
            return [-1], 0
        
        n = len(self.G)                 # number of nodes in the graph
        d = [float('inf')] * (n + 1)    # distance array, initialized to infinity
        p = [-1] * (n + 1)              # parent array to reconstruct paths
        d[start] = 0                    # distance to the start node is 0

        # relax all edges |V|-1 times
        for _ in range(n - 1):  # the variable is not used, but it is the number of edges
            for u in self.G:    # for each vertex
                for v, weight in self.G[u].items():  # for each edge

                    # if the distance to the current node is not infinity and the distance to the neighbor is greater than the distance to the current node plus the weight of the edge, update the distance and parent
                    if d[u] != float('inf') and d[u] + weight < d[v]:  
                        d[v] = d[u] + weight
                        p[v] = u

        # check for negative cycles
        for u in self.G:
            for v, weight in self.G[u].items():
                # if the distance to the current node is not infinity and the distance to the neighbor is greater than the distance to the current node plus the weight of the edge, raise an error
                if d[u] != float('inf') and d[u] + weight < d[v]:
                    raise ValueError("Negative cycle detected in the graph")

        # return the parent array and the shortest distance to the target node
        return p, d[target]
    
    
    def _has_negative_edges(self) -> bool:
        """
        Check if the graph contains any negative edges.
        
        Parameters:
        
        Returns:
            bool: True if negative edges exist, False otherwise
        """
        # iterate through all vertices and their edges
        for vertex in self.G:
            for neighbor, weight in self.G[vertex].items():
                # check if any edge weight is negative
                if weight < 0:
                    return True
        return False