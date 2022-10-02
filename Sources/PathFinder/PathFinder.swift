public struct Path {
    var nodes: [String]
    var cost: UInt32
    
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
}

public struct PathFinder {
    var nodes: [String: [String: UInt32]]  // Node: [Node: Cost]
    
    init(nodes: [String: [String: UInt32]]) {
        self.nodes = nodes
    }
    
    public func getShortestPath(from start: String, to destination: String) -> [String] {
        // Check edge cases
        if nodes[start] == nil || nodes[destination] == nil { return [] }
        if start == destination { return [start] }
        
        // Set unvisited nodes set, current path cost and current path variables
        var unvisitedNodes: [String] = Array(self.nodes.keys)
        var currentPathCost: [String: UInt32] = [start: 0]  // Node: Current Cost
        var currentPath: [String: [String]] = [start: [start]]  // Node: Current Path
        
        // Get start node
        guard let index = unvisitedNodes.firstIndex(of: start) else { return [] }
        var currentNode = unvisitedNodes.remove(at: index)
        
        while !unvisitedNodes.isEmpty {
            // Update neighbors paths cost
            self.nodes[currentNode]?.forEach { neighbor, cost in
                if unvisitedNodes.contains(neighbor) {
                    if currentPathCost[currentNode]! + cost < currentPathCost[neighbor] ?? UInt32.max {
                        currentPathCost[neighbor] = currentPathCost[currentNode]! + cost
                        currentPath[neighbor] = currentPath[currentNode]
                        currentPath[neighbor]!.append(neighbor)
                    }
                }
            }
            
            // Get next node and remove it from unvisited nodes
            // If there is no unvisited node with current path, set currentNode
            currentNode = currentPathCost.sorted { $0.value < $1.value }.first {
                unvisitedNodes.contains($0.key) }?.key ?? destination
            if currentPathCost[currentNode] == UInt32.max || currentNode == destination {
                return currentPath[destination] ?? []
            }
            guard let index = unvisitedNodes.firstIndex(of: currentNode) else { return [] }
            unvisitedNodes.remove(at: index)
        }
        
        return []
    }
}
