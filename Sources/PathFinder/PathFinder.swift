public typealias NodeID = String
public typealias Cost = UInt32


/// Represents the hop from the previous node.
private struct Hop: Equatable {
    internal var previousNode: NodeID
    internal var cost: Cost
    
    internal init(previousNode: NodeID, cost: Cost) {
        self.previousNode = previousNode
        self.cost = cost
    }
}

/// Represents a route between nodes.
public struct Path: Equatable {
    public var nodes: [NodeID]
    public var cost: Cost
    
    public init(nodes: [NodeID], cost: Cost) {
        self.nodes = nodes
        self.cost = cost
    }
    
    public init(from oldPath: Path, node: NodeID, cost: Cost) {
        self.nodes = oldPath.nodes
        self.nodes.append(node)
        self.cost = oldPath.cost + cost
    }
}

/// Represents a connection between two nodes.
public struct Edge: Equatable {
    public var source: NodeID
    public var destination: NodeID
    public var cost: Cost
    public var isBiDirectional: Bool
    
    public init(from source: NodeID, to destination: NodeID, cost: Cost, isBiDirectional: Bool = true) {
        self.source = source
        self.destination = destination
        self.cost = cost
        self.isBiDirectional = isBiDirectional
    }
    
    /// Gets the reversed edge.
    /// - Returns: The reversed edge.
    public func getReversed() -> Edge {
        return Edge(from: self.destination, to: self.source, cost: self.cost, isBiDirectional: false)
    }
}

/// A Dijkstra's algorithm manager.
public struct PathFinder {
    public var nodes: [NodeID: [NodeID: Cost]]  // Node: [Neighbor: Cost]
    
    public init(nodes: [NodeID: [NodeID: Cost]] = [:]) {
        self.nodes = nodes
    }
    
    public init(edges: [Edge]) {
        self.nodes = [:]
        self.addEdges(edges)
    }
    
    /// Gets the shortest path between two nodes.
    /// - Parameters:
    ///   - start: The node to start from.
    ///   - destination: The destination node.
    /// - Returns: The shortest path between the nodes if there is one, else nil.
    public func getShortestPath(from start: NodeID, to destination: NodeID) -> Path? {
        // Check edge cases
        if nodes[start] == nil || nodes[destination] == nil { return nil }
        if start == destination { return Path(nodes: [start], cost: 0) }
        
        // Set unvisited nodes set and hops dictionary
        var unvisitedNodes: Set<NodeID> = Set(self.nodes.keys)
        var hops: [NodeID: Hop] = [start: Hop(previousNode: start, cost: 0)]  // Node: Last Hop
        
        let totalCostOf: (NodeID) -> Cost? = { node in
            PathFinder.getTotalCost(of: node, hops: hops) }
        let fullPathOf: (NodeID) -> Path? = { node in
            PathFinder.getFullPath(of: node, hops: hops) }
        
        // Get start node
        guard var currentNode = unvisitedNodes.remove(start) else { return nil }
        
        while !unvisitedNodes.isEmpty {
            // Update neighbors' paths' cost
            guard let currentPathCost = totalCostOf(currentNode) else { return nil }
            self.nodes[currentNode]?.forEach { neighbor, cost in
                // Check if the neighbor is unvisited and if the new possible cost is cheaper than the old one
                if unvisitedNodes.contains(neighbor) && currentPathCost + cost < totalCostOf(neighbor) ?? Cost.max {
                    hops[neighbor] = Hop(previousNode: currentNode, cost: cost)
                }
            }
            
            // Get next node and remove it from unvisited nodes
            // If there is no unvisited node or if the next node is the destination, finish the process
            currentNode = unvisitedNodes.sorted {
                totalCostOf($0) ?? Cost.max < totalCostOf($1) ?? Cost.max }.first ?? destination
            if currentNode == destination {
                return fullPathOf(destination)
            }
            unvisitedNodes.remove(currentNode)
        }
        
        return nil
    }
    
    /// Adds an edge to the graph.
    /// - Parameter edge: The edge to add.
    public mutating func addEdge(_ edge: Edge) {
        // Update edge cost
        let currentCost: Cost = self.nodes[edge.source]?[edge.destination] ?? Cost.max
        if !self.nodes.keys.contains(edge.source) {
            self.nodes[edge.source] = [:]
        }
        self.nodes[edge.source]![edge.destination] = min(currentCost, edge.cost)
        
        if edge.isBiDirectional {
            self.addEdge(edge.getReversed())
        }
    }
    
    /// Adds multiple edges to the graph.
    /// - Parameter edges: The edges to add.
    public mutating func addEdges(_ edges: [Edge]) {
        edges.forEach { self.addEdge($0) }
    }
    
    /// Gets the full cost to get to a node.
    /// - Parameters:
    ///   - node: The node's identifier.
    ///   - hops: The getShortestPath.hops variable.
    /// - Returns: The current cost of the path from start to node if there is a path, else nil.
    private static func getTotalCost(of node: NodeID, hops: [NodeID: Hop]) -> Cost? {
        guard let hop = hops[node] else { return nil }
        // Check if this is the first hop
        if hop.previousNode == node { return 0 }
        // Get the previous node's path's cost
        guard let previousTotalCost = getTotalCost(of: hop.previousNode, hops: hops) else { return nil }
        // Return the path's total cost
        return previousTotalCost + hop.cost
    }
    
    /// Gets the path to node.
    /// - Parameters:
    ///   - node: The node's identifier.
    ///   - hops: The getShortestPath.hops variable.
    /// - Returns: The path from start to node if there is one, else nil.
    private static func getFullPath(of node: NodeID, hops: [NodeID: Hop]) -> Path? {
        guard let hop = hops[node] else { return nil }
        // Check if this is the first hop
        if hop.previousNode == node { return Path(nodes: [node], cost: hop.cost) }
        // Get the previous node's path
        guard let previousFullPath = getFullPath(of: hop.previousNode, hops: hops) else { return nil }
        // Return the path of this node
        return Path(from: previousFullPath, node: node, cost: hop.cost)
    }
}
