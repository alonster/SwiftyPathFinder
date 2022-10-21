//
//  TapGesture.swift
//  PathDemo
//

import SwiftUI

struct OnTap: ViewModifier {
    let response: (CGPoint) -> Void
    @State private var location: CGPoint = .zero
    
    func body(content: Content) -> some View {
        content
            .onTapGesture { response(location) }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { location = $0.location }
            )
    }
}

extension View {
    func onTapGesture(_ handler: @escaping (CGPoint) -> Void) -> some View {
        self.modifier(OnTap(response: handler))
    }
}
