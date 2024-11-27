import matplotlib.pyplot as plt
from shortest_path import ShortestPath
from mst import MST

class GraphPathFinder(ShortestPath,MST):
    def __init__(self, G:dict):
        """
        Initialize the ShortestPath class that combines functionalities
        of finding shortest paths and minimum spanning trees.

        Parameters:
            G (dict): Adjacency list representation of the graph where 
                      G[u] = {v: weight, ...} maps neighbors v of node u to their edge weights.
        """
        super().__init__(G)
        self.G = G

    def DFS(self,start:int) -> list:
        """
        Perform Depth First Search (DFS) on the graph.

        Parameters:
            start (int): Starting node for the DFS.

        Returns:
            list: Parent array representing the DFS tree.
        """
        n = len(self.G)     # number of nodes in the graph
        P = [-1] * (n + 1)  # parent array: stores the predecessor of each node (-1 indicates no predecessor)
        S = [0] * (n + 1)   # status array: 0 = unvisited, 1 = visiting, 2 = fully processed
        St = []             # stack to manage the nodes during traversal (depth-first)

        # add the starting node to the stack
        St.append(start)

        # process nodes until the stack is empty
        while St:
            # remove the last node from the stack (LIFO behavior for depth-first traversal)
            start = St.pop()
            
            # mark the current node as being visited
            S[start] = 1
            
            # visit all neighbors of the current node
            for v in reversed(self.G[start]):  # Reversing ensures consistent processing order
                # if the neighbor node is unvisited
                if S[v] == 0:
                    P[v] = start  # set the current node as the parent of the neighbor
                    St.append(v)  # add the neighbor to the stack for further processing
            
            # mark the current node as fully processed
            S[start] = 2

        # return the parent array, which represents the DFS tree
        return P
    
    def BFS(self,start:int) -> list:
        """
        Perform Breadth First Search (BFS) on the graph.

        Parameters:
            start (int): Starting node for the BFS.

        Returns:
            list: Parent array representing the BFS tree.
        """
        n = len(self.G)     # number of nodes in the graph
        P = [-1] * (n + 1)  # parent array: stores the predecessor of each node (-1 indicates no predecessor)
        S = [0] * (n + 1)   # status array: 0 = unvisited, 1 = visiting, 2 = fully processed
        Q = []              # queue to manage the nodes during traversal (FIFO behavior for BFS)

        # mark the starting node as visiting and enqueue it
        S[start] = 1
        Q.append(start)

        # process nodes until the queue is empty
        while Q:
            # remove the first node from the queue (FIFO behavior for breadth-first traversal)
            start = Q.pop(0)
            
            # visit all neighbors of the current node
            for v in self.G[start]:
                # if the neighbor node is unvisited
                if S[v] == 0:
                    S[v] = 1         # mark the neighbor as visiting
                    P[v] = start     # set the current node as the parent of the neighbor
                    Q.append(v)      # enqueue the neighbor for further processing
            
            # mark the current node as fully processed
            S[start] = 2

        # return the parent array, which represents the BFS tree
        return P

    def all_shortest_paths(self) -> dict:
        """
        Compute the shortest paths between all pairs of nodes in the graph.

        Returns:
            dict: A dictionary where keys are (start, target) pairs and values are 
                  tuples containing the path and value of minimum distance.
        """
        paths = {}

        # get all keys (nodes) in the graph
        keys = list(self.G.keys())

        # iterate over all pairs of nodes in the graph
        for i in range(len(keys)):
            for j in range(i + 1, len(keys)):  # consider pairs (i, j) where i < j to avoid duplication
                # compute the shortest-cost path from keys[i] to keys[j]
                P, dmin = self.shortest_cost_path(keys[i], keys[j])
                
                # reconstruct the path from the parent array
                path = self.rec_path(keys[i], keys[j], P)
                
                # store the path and its cost in the dictionary, keyed by the node pair
                paths[keys[i], keys[j]] = (path, dmin)

        # return the dictionary containing all paths and their associated costs
        return paths
    

    def plot_graph(self, C:dict, points: str = 'blue', line: str = 'b-', point_size: int = 2) -> None:
        """
        Plots a graph based on the given data.

        Parameters:
            C (dict): A dictionary containing coordinates.
            points (str): The color or style of the points. Default is 'red'.
            line (str): The color or style of the line. Default is 'k-'.

        Returns:
            None
        """
        # Plot the nodes
        # plt.figure(figsize=(8, 6))
        for node, (x, y) in C.items():
            plt.scatter(x, y, color=points, s=point_size)
            plt.text(x+5, y, str(node), fontsize=5, ha='left')

        # Plot the edges
        for node, neighbors in self.G.items():
            x_start, y_start = C[node]
            for neighbor in neighbors:
                x_end, y_end = C[neighbor]
                plt.plot([x_start, x_end], [y_start, y_end], line, lw=1)  # Line between nodes

        plt.xlabel("X-axis")
        plt.ylabel("Y-axis")
        plt.grid(True)

    def plot_path(self, path:list, C:dict, line: str = 'r-')-> None:
        """
        Plot a specific path on the graph.

        Parameters:
            path (list): List of nodes representing the path.
            C (dict): A dictionary mapping nodes to their (x, y) coordinates.
            line (str): Style/color for plotting the path. Default is 'r-'.

        Returns:
            None
        """
        x_coords = []
        y_coords = []

        for node in path:
            x, y = C[node]
            x_coords.append(x)
            y_coords.append(y)

        plt.plot(x_coords, y_coords, line, lw=1)

    def plot_node_names(self, municipalities: dict) -> None:
        for municipality, (x, y) in municipalities.items():
            plt.plot(x, y, 'ko', markersize=2)  # Black dots for municipalities

            # Plot white text as a halo with offsets
            for dx, dy in [(-10, 100), (10, 100), (0, 90), (0, 110), (-10, 90), (10, 110), (-10, 110), (10, 90)]:
                plt.text(x + dx, y + dy, municipality, fontsize=7, ha='center', color='white', weight='light')

                # Plot black text over the white halo
                plt.text(x, y + 100, municipality, fontsize=7, ha='center', color='black', weight='light')

    
    def rec_path(self, start:int, target:int, P:list) ->list:
        """
        Reconstruct the path from start to target using the parent array.

        Parameters:
            start (int): Starting node of the path.
            target (int): Target node of the path.
            P (list): Parent array representing the shortest path tree.

        Returns:
            list: The reconstructed path as a list of nodes.
        """
        path = []
        
        # initialize path reconstruction
        while target != start and target != -1:
            # append the current target node to the path
            path.append(target)
            # move to the parent of the current target node
            target = P[target]

        # append the start node to complete the path
        path.append(target)

        # check if the path is valid
        if target != start:
            print('Incorrect path')  # the path is invalid if it doesn't trace back to the start node

        # return the reconstructed path
        return path 