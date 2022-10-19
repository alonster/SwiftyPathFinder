//
//  EdgeView.swift
//  PathDemo
//

import SwiftUI

struct Line: Shape {
    var start: CGPoint
    var destination: CGPoint
    
    init(from start: CGPoint, to destination: CGPoint) {
        self.start = start
        self.destination = destination
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: start)
        path.addLine(to: destination)
        return path
    }
}

struct EdgeView: View {
    var start: CGPoint
    var destination: CGPoint
    
    init(from start: CGPoint, to destination: CGPoint) {
        self.start = start
        self.destination = destination
    }
    
    var body: some View {
        Line(from: start, to: destination)
            .stroke(.red, lineWidth: 5)
    }
}

struct EdgeView_Previews: PreviewProvider {
    static var previews: some View {
        let start = CGPoint(x: 60, y: 100)
        let destination = CGPoint(x: 300, y: 400)
        
        ZStack(alignment: .topLeading) {
            NodeView(color: .green, offset: start)
            NodeView(color: .orange, offset: destination)
            EdgeView(from: start, to: destination)
        }
    }
}
