//
//  CGPointExtension.swift
//  PathDemo
//

import SwiftUI

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
    
    /// Calculates the squared distance between two points.
    /// - Parameters:
    ///   - first: First point.
    ///   - second: Second point.
    /// - Returns: The distance between the two points, squared.
    public static func sqDistanceBetween(_ first: CGPoint, and second: CGPoint) -> CGFloat {
        return (first.x - second.x) * (first.x - second.x) + (first.y - second.y) * (first.y - second.y)
    }
    
    public static func distanceBetween(_ first: CGPoint, and second: CGPoint) -> CGFloat {
        return sqrt(sqDistanceBetween(first, and: second))
    }
}
