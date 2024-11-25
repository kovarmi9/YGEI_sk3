from queue import PriorityQueue

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


def prim_algorithm(graph):
    n = len(graph)
    v = [0] * (n + 1)  # Track visited nodes
    pq = PriorityQueue()  # Priority queue to store edges
    wt = 0  # Total weight
    T = []  # List to store T edges

    # Start from the first node in the graph
    keys = list(graph.keys())
    start_node = keys[0]

    # Add all edges from the start node to the priority queue
    for neighbor, weight in graph[start_node].items():
        pq.put((weight, start_node, neighbor))

    v[start_node] = 1  # Mark start node as visited

    while not pq.empty():
        # Get the edge with the smallest weight
        weight, from_node, to_node = pq.get()

        if not v[to_node]:
            v[to_node] = 1  # Mark the node as visited
            T.append((from_node, to_node, weight))  # Add edge to T
            wt += weight  # Update total weight

            # Add edges from the newly visited node
            for neighbor, edge_weight in graph[to_node].items():
                if not v[neighbor]:
                    pq.put((edge_weight, to_node, neighbor))

    return T, wt




print('ok')