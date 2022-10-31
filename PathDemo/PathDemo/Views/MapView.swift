//
//  MapView.swift
//  PathDemo
//

import SwiftUI
import PathFinder

struct MapView: View {
    @State var nodes: [CGPoint] = []
    @State var start: CGPoint? = nil
    @State var destination: CGPoint? = nil
    @State var edges: [CGPoint: CGPoint] = [:]
    @State var pathCost: Cost? = nil
    
    @State private var mode: MapMode = MapMode.setStart
    
    enum MapMode: Identifiable, CaseIterable {
        case setStart
        case setDest
        case addNode
        
        var id: MapMode { self }
        var description: String {
            switch self {
            case .setStart:
                return "Set Start"
            case .setDest:
                return "Set Destination"
            case .addNode:
                return "Add Node"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Mode", selection: $mode) {
                    ForEach(MapMode.allCases) { mode in
                        Text(mode.description)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .foregroundColor(Color(.systemGray2))
                    ForEach(nodes, id: \.self) { node in
                        NodeView(color: .blue, offset: node)
                    }
                    if let start = start {
                        NodeView(color: .orange, offset: start)
                    }
                    if let destination = destination {
                        NodeView(color: .green, offset: destination)
                    }
                    ForEach(Array(edges.keys), id: \.self) { key in
                        EdgeView(from: key, to: edges[key]!)
                    }
                }
                .onTapGesture { point in self.handleTapOn(point) }
                
                HStack {
                    VStack(alignment: .leading) {
                        if let start = start, let destination = destination,
                            let airDistance = Int(CGPoint.distanceBetween(start, and: destination)) {
                            Text("Air destination: " + String(airDistance))
                        }
                        if let cost = pathCost {
                            Text("Path cost: " + String(cost))
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: { self.findShortestPath() }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.green)
                                .frame(width: 100, height: nil)
                            Text("Find")
                                .foregroundColor(.primary)
                        }
                    }
                }
                .frame(width: nil, height: 60, alignment: .top)
                .padding(10)
            }
            .navigationTitle("Map")
        }
    }
    
    private func handleTapOn(_ point: CGPoint) {
        switch self.mode {
        case MapMode.setStart:
            self.start = point
            break
        case MapMode.setDest:
            self.destination = point
            break
        case MapMode.addNode:
            self.nodes.append(point)
            break
        }
    }
    
    /// Find the shortest path between the start and destination.
    private func findShortestPath() {
        self.edges.removeAll()
        pathCost = nil
        
        var graphEdges: [PFEdge] = []
        var nodes: [CGPoint] = self.nodes
        guard let start = self.start else { return }
        nodes.insert(start, at: 0)
        guard let destination = self.destination else { return }
        nodes.insert(destination, at: 1)
        
        for index in nodes.indices {
            for nextNodeIndex in nodes[index + 1 ..< nodes.indices.endIndex].indices {
                if let cost = self.costOfEdgeBetween(nodes[index], and: nodes[nextNodeIndex]) {
                    graphEdges.append(
                        PFEdge(from: NodeID(index), to: NodeID(nextNodeIndex), cost: cost))
                }
            }
        }
                
        let finder = PathFinder(edges: graphEdges)
        if let path = finder.getShortestPath(from: "0", to: "1") {
            pathCost = path.cost
            for pathNodeIndex in path.nodes.indices.dropLast() {
                guard let startIndex = Int(path.nodes[pathNodeIndex]) else { return }
                guard let destinationIndex = Int(path.nodes[pathNodeIndex + 1]) else { return }
                self.edges[nodes[startIndex]] = nodes[destinationIndex]
            }
        }
    }
    
    private func costOfEdgeBetween(_ first: CGPoint, and second: CGPoint) -> Cost? {
        let sqDistance = CGPoint.sqDistanceBetween(first, and: second)
        return sqDistance < pow(100, 2) ? Cost(sqrt(sqDistance)) : nil
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(nodes: [CGPoint(x: 220, y: 80), CGPoint(x: 300, y: 300), CGPoint(x: 160, y: 500)],
            start: CGPoint(x: 320, y: 550), destination: CGPoint(x: 40, y: 100))
    }
}
