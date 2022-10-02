public struct PathFinder {
    var nodes: [String: [String: UInt32]]  // Node: [Node: Cost]
    
    init(nodes: [String: [String: UInt32]]) {
        self.nodes = nodes
    }
    
    public func getShortestPath(from start: String, to destination: String) -> [String] {
        // TODO: implement function
        return []
    }
}
