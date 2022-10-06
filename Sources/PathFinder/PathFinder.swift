public typealias NodeID = String
public typealias Cost = UInt32


private struct Hop: Equatable {
    var previousNode: NodeID
    var cost: Cost
    
    init(previousNode: NodeID, cost: Cost) {
        self.previousNode = previousNode
        self.cost = cost
    }
}

public struct Path: Equatable {
    var nodes: [NodeID]
    var cost: Cost
    
    init() {
        self.nodes = []
        self.cost = Cost.max
    }
    
    init(nodes: [NodeID], cost: Cost) {
        self.nodes = nodes
        self.cost = cost
    }
    
    init(from oldPath: Path, node: NodeID, cost: Cost) {
        self.nodes = oldPath.nodes
        self.nodes.append(node)
        self.cost = oldPath.cost + cost
    }
}

public struct Edge: Equatable {
    var source: NodeID
    var destination: NodeID
    var cost: Cost
    var isBiDirectional: Bool
    
    init(from source: NodeID, to destination: NodeID, cost: Cost, isBiDirectional: Bool = true) {
        self.source = source
        self.destination = destination
        self.cost = cost
        self.isBiDirectional = isBiDirectional
    }
    
    public func getReversed() -> Edge {
        return Edge(from: self.destination, to: self.source, cost: self.cost, isBiDirectional: false)
    }
}

public struct PathFinder {
    var nodes: [NodeID: [NodeID: Cost]]  // Node: [Neighbor: Cost]
    
    init(nodes: [NodeID: [NodeID: Cost]] = [:]) {
        self.nodes = nodes
    }
    
    init(edges: [Edge]) {
        self.nodes = [:]
        self.addEdges(edges)
    }
    
    public func getShortestPath(from start: NodeID, to destination: NodeID) -> Path {
        // Check edge cases
        if nodes[start] == nil || nodes[destination] == nil { return Path() }
        if start == destination { return Path(nodes: [start], cost: 0) }
        
        // Set unvisited nodes set and hops dictionary
        var unvisitedNodes: Set<NodeID> = Set(self.nodes.keys)
        var hops: [NodeID: Hop] = [start: Hop(previousNode: start, cost: 0)]  // Node: Last Hop
        
        let totalCostOf: (NodeID) -> Cost = { node in
            PathFinder.getTotalCost(of: node, hops: hops) }
        let fullPathOf: (NodeID) -> Path = { node in
            PathFinder.getFullPath(of: node, hops: hops) }
        
        // Get start node
        guard var currentNode = unvisitedNodes.remove(start) else { return Path() }
        
        while !unvisitedNodes.isEmpty {
            // Update neighbors' paths' cost
            self.nodes[currentNode]?.forEach { neighbor, cost in
                // Check if the neighbor is unvisited and if the new possible cost is cheaper than the old one
                if unvisitedNodes.contains(neighbor) && totalCostOf(currentNode) + cost < totalCostOf(neighbor) {
                    hops[neighbor] = Hop(previousNode: currentNode, cost: cost)
                }
            }
            
            // Get next node and remove it from unvisited nodes
            // If there is no unvisited node or if the next node is the destination, finish the process
            currentNode = unvisitedNodes.sorted { totalCostOf($0) < totalCostOf($1) }.first ?? destination
            if currentNode == destination {
                return fullPathOf(destination)
            }
            unvisitedNodes.remove(currentNode)
        }
        
        return Path()
    }
    
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
    
    public mutating func addEdges(_ edges: [Edge]) {
        edges.forEach { self.addEdge($0) }
    }
    
    private static func getTotalCost(of node: NodeID, hops: [NodeID: Hop]) -> Cost {
        guard let hop = hops[node] else { return Cost.max }
        // Check if this is the first hop
        if hop.previousNode == node { return 0 }
        // Get the previous node's path's cost
        let previousTotalCost = getTotalCost(of: hop.previousNode, hops: hops)
        // Check if an error occurred
        if previousTotalCost == Cost.max { return Cost.max }
        // Return the path's total cost
        return previousTotalCost + hop.cost
    }
    
    private static func getFullPath(of node: NodeID, hops: [NodeID: Hop]) -> Path {
        guard let hop = hops[node] else { return Path() }
        // Check if this is the first hop
        if hop.previousNode == node { return Path(nodes: [node], cost: hop.cost) }
        // Get the previous node's path
        let previousFullPath = getFullPath(of: hop.previousNode, hops: hops)
        // Check if an error occurred
        if previousFullPath == Path() { return Path() }
        // Return the path of this node
        return Path(from: previousFullPath, node: node, cost: hop.cost)
    }
}
