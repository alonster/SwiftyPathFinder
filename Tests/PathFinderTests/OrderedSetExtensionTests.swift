import XCTest
@testable import OrderedCollections

final class OrderedSetSortFromTests: XCTestCase {
    var map = [
        "A": 1,
        "B": 2,
        "C": 3,
        "D": 4
    ]
    var set = OrderedSet(["A", "B", "C", "D"])
    
    func testNothingChanged() {
        set.sort(from: "C") { map[$0]! < map[$1]! }
        XCTAssertEqual(set, OrderedSet(["A", "B", "C", "D"]))
    }
    
    func testEvenNumberOfElements() {
        map["C"] = 0
        set.sort(from: "C") { map[$0]! < map[$1]! }
        XCTAssertEqual(set, OrderedSet(["C", "A", "B", "D"]))
    }
    
    func testOddNumberOfElements() {
        map["E"] = 6
        set.append("E")
        map["D"] = 0
        set.sort(from: "D") { map[$0]! < map[$1]! }
        XCTAssertEqual(set, OrderedSet(["D", "A", "B", "C", "E"]))
    }
    
    func testFirstChanged() {
        map["A"] = 6
        set.sort(from: "A") { map[$0]! < map[$1]! }
        XCTAssertEqual(set, OrderedSet(["B", "C", "D", "A"]))
    }
    
    func testLastChanged() {
        map["D"] = 0
        set.sort(from: "D") { map[$0]! < map[$1]! }
        XCTAssertEqual(set, OrderedSet(["D", "A", "B", "C"]))
    }
    
    func testChangedToMiddle() {
        map["A"] = 6
        set.sort(from: "A") { map[$0]! < map[$1]! }
        map["B"] = 5
        set.sort(from: "B") { map[$0]! < map[$1]! }
        XCTAssertEqual(set, OrderedSet(["C", "D", "B", "A"]))
    }
    
    func testLargeSet() {
        let largeSetCheck: OrderedSet<Int> = OrderedSet(
            [1, 2, 74, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27,
             28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52,
             53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 75, 76, 77, 78,
             79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100])
        
        var largeMap: [Int: Int] = [:]
        var largeSet: OrderedSet<Int> = OrderedSet([])
        for index in 1...100 {
            largeMap[index] = index
            largeSet.append(index)
        }
        
        largeSet.remove(3)
        largeMap[74] = 3
        largeSet.sort(from: 74) { largeMap[$0]! < largeMap[$1]! }
        
        XCTAssertEqual(largeSet, largeSetCheck)
    }
}
