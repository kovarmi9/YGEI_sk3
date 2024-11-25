import matplotlib.pyplot as plt

G = {
    1 : {2:8, 3:4, 5:2},
    2 : {1:8, 3:5, 4:2, 7:6, 8:7},
    3 : {1:4, 2:5, 6:3, 7:4},
    4 : {2:2, 9:3},
    5 : {1:2, 6:5},
    6 : {3:3, 5:5, 7:5, 8:7, 9:10},
    7 : {2:6, 3:4, 6:5, 8:3},
    8 : {2:7, 6:7, 7:3, 9:1},
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


def make_list(G):
    V = G.keys()
    E = [];
    for nodeS in V:
        for nodeE, weight in G[nodeS].items():
            E.append([nodeS,nodeE,weight])
    return V,E

V, E = make_list(G)

def find(u,P):
    while (P[u] != u): #Find root
        u = P[u]
    root = u
    while u != root:
        up = P[u] #Store predecessor
        P[u] = root #Change predecessor to root
        u = up #Go to parent
    return u

def union(u,v,P):
    # Union find
    
    # Find node for u
    root_u = find(u,P)
    # Find node for v
    root_v = find(v,P)
    if root_u != root_v:
        P[root_u] = root_v
    return P

def weighted_union(u, v, p, r):
    root_u = find(u, p)
    root_v = find(v, p)
    if root_u != root_v:
        if r[root_u] > r[root_v]:
            p[root_v] = root_u
        elif r[root_v] > r[root_u]:
            r[root_v] > r[root_u]
            p[root_u] = root_v
        else:
            p[root_u] = root_v
            r[root_v] = r[root_v]+1 
    return p,r


def boruvka (V,E):
    T = [] # tree
    wt = 0 # line weight
    n = len(V)
    P = [-1] * (n+1)
    r = [0] * (n+1)

    # Inicialization trees
    for v in V:
        P[v] = v
 
    # sort edges
    ES = sorted(E, key=lambda it:it[2])
    
    
    # Process sorted edges
    for e in ES:
        u, v, w = e
        
        # Union find
        if find(u,P) != find(v,P):
            P,r = weighted_union(u, v, P, r)
            
            # add e 
            T.append(e)
            
            wt = wt + w
    return wt, T

wt, T = boruvka (V,E)

print (wt,T)


def plot_min_span_tree(C:dict, T:list, line:str = 'k-'):
    x_edges = []
    y_edges = []

    for start, end, weight in T:
        x_edges.extend([C[start][0],C[end][0],None])
        y_edges.extend([C[start][1],C[end][1],None])

    plt.plot(x_edges, y_edges, line, lw=1)
    plt.grid(True)
    plt.axis("equal")
    pass

plot_min_span_tree(C,T)
plt.show()
