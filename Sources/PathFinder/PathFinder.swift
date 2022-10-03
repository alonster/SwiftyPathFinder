public struct Path: Equatable {
    var nodes: [String]
    var cost: UInt32
    
    init() {
        self.nodes = []
        self.cost = UInt32.max
    }
    
    init(nodes: [String], cost: UInt32) {
        self.nodes = nodes
        self.cost = cost
    }
    
    init(from oldPath: Path, node: String, cost: UInt32) {
        self.nodes = oldPath.nodes
        self.nodes.append(node)
        self.cost = oldPath.cost
        self.cost += cost
    }
    
    public static func == (lhs: Path, rhs: Path) -> Bool {
        return lhs.nodes == rhs.nodes && lhs.cost == rhs.cost
    }
}

public struct Edge: Equatable {
    var source: String
    var destination: String
    var cost: UInt32
    var isBiDirectional: Bool
    
    init(from source: String, to destination: String, cost: UInt32, isBiDirectional: Bool = true) {
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
    var nodes: [String: [String: UInt32]]  // Node: [Node: Cost]
    
    init(nodes: [String: [String: UInt32]] = [:]) {
        self.nodes = nodes
    }
    
    init(edges: [Edge]) {
        self.nodes = [:]
        self.addEdges(edges)
    }
    
    public func getShortestPath(from start: String, to destination: String) -> Path {
        // Check edge cases
        if nodes[start] == nil || nodes[destination] == nil { return Path() }
        if start == destination { return Path(nodes: [start], cost: 0) }
        
        // Set unvisited nodes set, current path cost and current path variables
        var unvisitedNodes: [String] = Array(self.nodes.keys)
        var currentPath: [String: Path] = [start: Path(nodes: [start], cost: 0)]  // Node: Shortest Path
        
        // Get start node
        guard let index = unvisitedNodes.firstIndex(of: start) else { return Path() }
        var currentNode = unvisitedNodes.remove(at: index)
        
        while !unvisitedNodes.isEmpty {
            // Update neighbors paths cost
            self.nodes[currentNode]?.forEach { neighbor, cost in
                if unvisitedNodes.contains(neighbor) {
                    if currentPath[currentNode]!.cost + cost < currentPath[neighbor]?.cost ?? UInt32.max {
                        currentPath[neighbor] = Path(from: currentPath[currentNode]!,
                                                     node: neighbor, cost: cost)
                    }
                }
            }
            
            // Get next node and remove it from unvisited nodes
            // If there is no unvisited node with current path, set currentNode to destination
            currentNode = currentPath.sorted { $0.value.cost < $1.value.cost }.first {
                unvisitedNodes.contains($0.key) }?.key ?? destination
            if currentPath[currentNode]?.cost ?? UInt32.max == UInt32.max || currentNode == destination {
                return currentPath[destination] ?? Path()
            }
            guard let index = unvisitedNodes.firstIndex(of: currentNode) else { return Path() }
            unvisitedNodes.remove(at: index)
        }
        
        return Path()
    }
    
    public mutating func addEdge(_ edge: Edge) {
        // Update edge cost
        let currentCost: UInt32 = self.nodes[edge.source]?[edge.destination] ?? UInt32.max
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
}
