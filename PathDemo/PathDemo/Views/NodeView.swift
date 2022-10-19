//
//  NodeView.swift
//  PathDemo
//

import SwiftUI

struct NodeView: View {
    var color: Color
    var size: CGFloat = 20
    var offset: CGPoint = .zero
    
    init(color: Color, size: CGFloat = 20, xOffset: CGFloat = 0, yOffset: CGFloat = 0) {
        self.color = color
        self.size = size
        self.offset = CGPoint(x: xOffset, y: yOffset)
    }
    
    init(color: Color, size: CGFloat = 20, offset: CGPoint) {
        self.color = color
        self.size = size
        self.offset = offset
    }
    
    var body: some View {
        Circle()
            .foregroundColor(self.color)
            .frame(width: self.size, height: self.size)
            .offset(x: self.offset.x - 0.5 * self.size, y: self.offset.y - 0.5 * self.size)
    }
}

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                NodeView(color: .red, size: 50)
                NodeView(color: .blue, size: 50)
            }
            HStack {
                NodeView(color: .red)
                NodeView(color: .blue)
                NodeView(color: .green)
                NodeView(color: .gray)
            }
            ZStack(alignment: .topLeading) {
                NodeView(color: .red, xOffset: 20)
                NodeView(color: .blue, yOffset: 20)
                NodeView(color: .green, size: 40, offset: CGPoint(x: 60, y: 30))
            }
            .frame(width: nil, height: 100)
        }
    }
}
