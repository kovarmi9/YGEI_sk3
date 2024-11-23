def belmanFord(G, source, target):
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
                raise ValueError("Graph contains negative cycle")
    
    # Return the shortest distance and the path
    return d[target], p