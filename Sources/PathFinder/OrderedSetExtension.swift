import OrderedCollections

extension OrderedSet {
    
    /// Sort the OrderedSet when it is known which Element has changed.
    /// - Parameters:
    ///   - from: The Changed Element.
    ///   - areInIncreasingOrder: A predicate that returns `true` if its
    ///   first argument should be ordered before its second argument; otherwise, `false`.
    ///
    /// - Complexity: O(log *n*), where *n* is the length of the sequence.
    public mutating func sort(from element: Element, by areInIncreasingOrder: (Element, Element) throws -> Bool) {
        self.remove(element)
        var lowIndex = self.startIndex
        var highIndex = self.endIndex
        
        while lowIndex != highIndex {
            let midIndex = index(lowIndex, offsetBy: distance(from: lowIndex, to: highIndex) / 2)
            if try! areInIncreasingOrder(element, self[midIndex]) {
                highIndex = midIndex
            } else {
                lowIndex = index(after: midIndex)
            }
        }
        
        self.insert(element, at: lowIndex)
    }
}
