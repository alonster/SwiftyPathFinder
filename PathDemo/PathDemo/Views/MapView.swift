//
//  MapView.swift
//  PathDemo
//

import SwiftUI

struct MapView: View {
    @State var nodes: [CGPoint] = []
    @State var start: CGPoint? = nil
    @State var destination: CGPoint? = nil
    
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
                }
                .onTapGesture { point in self.handleTapOn(point) }
                
                HStack {
                    Spacer()
                    
                    Button(action: {}) {
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
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(nodes: [CGPoint(x: 220, y: 80), CGPoint(x: 300, y: 300), CGPoint(x: 160, y: 500)],
            start: CGPoint(x: 320, y: 550), destination: CGPoint(x: 40, y: 100))
    }
}
