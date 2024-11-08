import matplotlib.pyplot as plt

# Graph definition
G = {
    1 : [2, 3, 5],
    2 : [1, 3, 4, 7, 8],
    3 : [1, 2, 6, 7],
    4 : [2, 9],
    5 : [1, 6],
    6 : [3, 5, 7, 8, 9],
    7 : [2, 3, 6, 8],
    8 : [2, 6, 7, 9],
    9 : [4, 6, 8]
}

#Coordinates X, Y
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


# BFS
def BFS(G,u):
    # Input data structures
    n = len(G)
    P = [-1] * (n + 1)
    S = [0] * (n + 1)
    Q = []
    # Starting node, change status
    S[u] = 1
    
    # Add to queve
    Q.append(u)
    
    # Until Q is emtpy
    while Q:
        
        # Remove first node
        u = Q.pop(0)
        
        # Visit all neigbours
        for v in G[u]:
            
            # Check if node is new
            if S[v] == 0:
                S[v] = 1
                P[v] = u
                Q.append(v)
                
        # Close Node
        S[u] = 2
        
    return(P)

def recPath(u,v,P):
    path = [] 
    
    # Path shortening
    while v != u and v != -1:
        path.append(v)
        v = P[v]
        
    path.append(v)
    if v != u:
        print('Incorrect path')
    return path

def DFS(G,u):
    # Input data structures
    n = len(G)
    P = [-1] * (n + 1)
    S = [0] * (n + 1)
    St = [] #Stack
    # Starting node, change status
    #S[u] = 1
    
    # Add to queve
    St.append(u)
    
    # Until Q is emtpy
    while St:
        
        # Remove first node
        u = St.pop()
        
        # Starting node, change status
        S[u] = 1
        # Visit all neigbours
        for v in reversed(G[u]):
            
            # Check if node is new
            if S[v] == 0:
                P[v] = u
                St.append(v)
                
        # Close Node
        S[u] = 2
        
    return(P)

# Run BFS
P = BFS(G,2)
print(P)

# Backward reconstruction
path = recPath(2,9,P)
print(path)

P = DFS(G,1)
print(P)

path = recPath(1,4,P)
print(path)


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


PlotGraph(G, C)
PlotPath(path, C)
plt.show()
print('Done')