import matplotlib.pyplot as plt
from graph_path_finder import GraphPathFinder

class ShortestPath(GraphPathFinder):
    def __init__(self, G:dict):
        super().__init__()
        self.G = G

    def DFS(self,start:int):
        # Input data structures
        n = len(self.G)
        P = [-1] * (n + 1)
        S = [0] * (n + 1)
        St = [] #Stack
        # Starting node, change status
        #S[u] = 1
        
        # Add to queve
        St.append(start)
        
        # Until Q is emtpy
        while St:
            
            # Remove first node
            start = St.pop()
            
            # Starting node, change status
            S[start] = 1
            # Visit all neigbours
            for v in reversed(self.G[start]):
                
                # Check if node is new
                if S[v] == 0:
                    P[v] = start
                    St.append(v)
                    
            # Close Node
            S[start] = 2
            
        return(P)
    
    def BFS(self,start:int):
        # Input data structures
        n = len(self.G)
        P = [-1] * (n + 1)
        S = [0] * (n + 1)
        Q = []
        # Starting node, change status
        S[start] = 1
        
        # Add to queve
        Q.append(start)
        
        # Until Q is emtpy
        while Q:
            
            # Remove first node
            start = Q.pop(0)
            
            # Visit all neigbours
            for v in self.G[start]:
                
                # Check if node is new
                if S[v] == 0:
                    S[v] = 1
                    P[v] = start
                    Q.append(v)
                    
            # Close Node
            S[start] = 2
            
        return(P)

    def all_shortest_paths(self):
        paths = {}
        keys = list(self.G.keys())
        for i in range(len(keys)):
            for j in range(i + 1, len(keys)):
                P, dmin = self.shortest_cost_path(self.G, keys[i], keys[j])
                path = self.rec_path(keys[i], keys[j], P)
                paths[keys[i], keys[j]] = (path, dmin)

        return paths
    

    def plot_graph(self, C:dict, points: str = 'red', line: str = 'k-'):
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
        plt.figure(figsize=(8, 6))
        for node, (x, y) in C.items():
            plt.scatter(x, y, color=points)
            plt.text(x+5, y, str(node), fontsize=12, ha='left')

        # Plot the edges
        for node, neighbors in self.G.items():
            x_start, y_start = C[node]
            for neighbor in neighbors:
                x_end, y_end = C[neighbor]
                plt.plot([x_start, x_end], [y_start, y_end], line, lw=1)  # Line between nodes

        plt.xlabel("X-axis")
        plt.ylabel("Y-axis")
        plt.grid(True)
        pass

    def plot_path(self, path:list, C:dict, line: str = 'r-'):
        for node in range(len(path)-1):
            x_start, y_start = C[path[node]]
            x_end, y_end = C[path[node+1]]
            plt.plot([x_start, x_end], [y_start, y_end], line , lw=1)

        pass
    
    def rec_path(self, start:int, target:int, P:list):
        path = []
        
        # Path shortening
        while target != start and target != -1:
            path.append(target)
            target = P[target]

        path.append(target)
        if target != start:
            print('Incorrect path')
        return path   