import OrderedCollections
import AppKit

extension OrderedSet {
    
    /// Sort the OrderedSet when it is known which Element has changed.
    /// - Parameters:
    ///   - from: The Changed Element.
    ///   - areInIncreasingOrder: A predicate that returns `true` if its
    ///   first argument should be ordered before its second argument; otherwise, `false`.
    ///
    /// - Complexity: O(log *n*), where *n* is the length of the sequence.
    public mutating func sort(from element: Element, by areInIncreasingOrder: (Element, Element) throws -> Bool) {
    }
}
