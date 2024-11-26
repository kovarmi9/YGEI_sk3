import matplotlib.pyplot as plt
from queue import PriorityQueue

class MST:
    """
        Initialize the MST class with the given graph.

        Parameters:
            G (dict): Adjacency list representation of the graph where 
                      G[u] = {v: weight, ...} maps neighbors v of node u to their edge weights.
        """
    def __init__(self, G:dict):
        self.G = G

    def prim(self) -> tuple[list, float]:
        """
        Compute the Minimum Spanning Tree (MST) using Prim's algorithm.

        Returns:
            tuple[list, float]: 
                - List of edges (start_node, end_node, weight) in the MST.
                - Total weight of the MST.
        """
        n = len(self.G)
        v = [0] * (n + 1)     # track visited nodes
        pq = PriorityQueue()  # priority queue to store edges
        wt = 0                # total weight
        T = []                # list to store T edges

        # start from the first node in the graph
        keys = list(self.G.keys())
        start_node = keys[0]

        # add all edges from the start node to the priority queue
        for neighbor, weight in self.G[start_node].items():
            pq.put((weight, start_node, neighbor))

        v[start_node] = 1  # mark start node as visited

        while not pq.empty():
            # get the edge with the smallest weight
            weight, from_node, to_node = pq.get()

            if not v[to_node]:
                v[to_node] = 1                          # mark the node as visited
                T.append((from_node, to_node, weight))  # add edge to T
                wt += weight                            # update total weight

                # Add edges from the newly visited node
                for neighbor, edge_weight in self.G[to_node].items():
                    if not v[neighbor]:
                        pq.put((edge_weight, to_node, neighbor))

        # return the minimum spanning tree (T) and its total weight (wt)
        return T, wt
    
    def boruvka (self) -> tuple[list, float]:
        """
        Compute the Minimum Spanning Tree (MST) using Boruvka's algorithm.

        Returns:
            tuple[list, float]: 
                - List of edges (start_node, end_node, weight) in the MST.
                - Total weight of the MST.
        """
        # Generate the list of vertices (V) and edges (E)
        V, E = self._make_list()

        # initialize the tree and total weight variables
        T = []              # list to store the edges of the minimum spanning tree (MST)
        wt = 0              # total weight of the MST
        n = len(V)          # number of vertices
        P = [-1] * (n+1)    # parent array for union-find (disjoint set)
        r = [0] * (n+1)     # rank array for union-find (used for balancing the tree)

        # initialization: Each vertex is its own parent (each vertex is in its own tree)
        for v in V:
            P[v] = v
            
        # sort edges by weight (ascending order)
        ES = sorted(E, key=lambda it:it[2])

        # process each edge in sorted order
        for e in ES:
            u, v, w = e  # extract the two vertices (u, v) and the weight (w) of the edge
            
            # if u and v belong to different sets (they are not connected in the MST)
            if self._find(u, P) != self._find(v, P):
                # perform the union operation to connect u and v, update parent and rank arrays
                P, r = self._weighted_union(u, v, P, r)
                
                # add the edge e to the MST
                T.append(e)
                
                # add the weight of the edge to the total weight of the MST
                wt += w

        # return the minimum spanning tree (T) and its total weight (wt)
        return T, wt
    
    def plot_mst(self,C:dict, T:list, line:str = 'b-') -> None:
        """
        Plot the Minimum Spanning Tree (MST) on a 2D graph.

        Parameters:
            C (dict): A dictionary mapping nodes to their (x, y) coordinates.
            T (list): A list of edges in the MST (start_node, end_node, weight).
            line (str): The color or style of the line. Default is 'b-'.

        Returns:
            None
        """
        x_edges = []  # x-coordinates of the edges to be plotted
        y_edges = []  # y-coordinates of the edges to be plotted

        # loop through each edge in the tree (T)
        for start, end, weight in T:
            # add the x and y coordinates of the start and end points of the edge
            # also add a None value to break the line between consecutive edges when plotting
            x_edges.extend([C[start][0], C[end][0], None])
            y_edges.extend([C[start][1], C[end][1], None])

        # plot the edges using the generated x and y coordinates
        plt.plot(x_edges, y_edges, line, lw=1)  # plot with specified line style and linewidth

        # add a grid to the plot for better visualization
        plt.grid(True)

        # set the axes to have equal scaling for a proportional display
        plt.axis("equal")


    def _make_list(self) -> tuple[list,list]:
        """
        Convert the graph into a list of vertices and edges.

        Returns:
            tuple[list, list]:
                - V : List of vertices in the graph.
                - E : List of edges, where each edge is represented as [start_node, end_node, weight].
        """
        V = self.G.keys()  # V represents the set of nodes in the graph

        # initialize an empty list to store the edges
        E = []

        # iterate through each node in the graph
        for nodeS in V:
            # for each neighbor of the current node (nodeS), get the target node (nodeE) and edge weight
            for nodeE, weight in self.G[nodeS].items():
                # add the edge as a list [source_node, target_node, weight] to the edges list
                E.append([nodeS, nodeE, weight])

        # return the set of nodes (V) and the list of edges (E)
        return V, E
    
    def _find(self,u:int,P:list) -> None:
        """
        Find the root of the node u using the Union-Find method (with path compression).

        Parameters:
            u (int): Node for which the root is to be found.
            P (list): Parent array representing the Union-Find structure.

        Returns:
            int: The root of the node u.
        """
        while (P[u] != u):  # traverse up the tree until the root is reached
            u = P[u]        # move to the parent node

        # store the root of the set
        root = u

        # perform path compression to optimize future queries
        while u != root:    # traverse back down from the original node to the root
            up = P[u]       # store the parent of the current node
            P[u] = root     # directly link the current node to the root (path compression)
            u = up          # move to the parent node

        # return the root of the set
        return u
    
    def _weighted_union(self, u:int, v:int, p:list, r:list) -> tuple[list, list]:
        """
        Perform the union of two sets containing nodes u and v using the Union-Find method,
        with weighted union to keep the tree balanced.

        Parameters:
            u (int): First node to be united.
            v (int): Second node to be united.
            p (list): Parent array representing the Union-Find structure.
            r (list): Rank array representing the Union-Find structure.

        Returns:
            tuple[list, float]: 
                - Updated parent array.
                - Updated rank array.
        """
        root_u = self._find(u, p)  # root of the set containing node u
        root_v = self._find(v, p)  # root of the set containing node v

        # check if the roots are different (i.e., u and v are in different sets)
        if root_u != root_v:
            # compare the ranks of the roots to decide which tree to merge into the other
            if r[root_u] > r[root_v]:  
                # if root_u's tree has a higher rank, make root_v's parent root_u
                p[root_v] = root_u
            elif r[root_v] > r[root_u]:  
                # if root_v's tree has a higher rank, make root_u's parent root_v
                p[root_u] = root_v
            else:
                # if both have the same rank:
                # make root_u's parent root_v
                p[root_u] = root_v
                # increment the rank of root_v since the tree height increases
                r[root_v] = r[root_v] + 1

        # return the updated parent (p) and rank (r) arrays
        return p, r