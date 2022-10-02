import XCTest
@testable import PathFinder

final class PathFinderTests: XCTestCase {
    var simpleGraph: [String: [String: UInt32]] = [
        "A": ["B": 2, "C": 6],
        "B": ["A": 2, "D": 5],
        "C": ["A": 6, "D": 3],
        "D": ["B": 5, "C": 3, "E": 10, "F": 13],
        "E": ["D": 10, "F": 6, "G": 2],
        "F": ["D": 13, "E": 6, "G": 6],
        "G": ["E": 2, "F": 6]
    ]
    
    func testUnknownStartOrDestination() {
        let finder = PathFinder(nodes: simpleGraph)
        XCTAssertEqual(finder.getShortestPath(from: "0", to: "A"), [])
        XCTAssertEqual(finder.getShortestPath(from: "A", to: "0"), [])
    }
    
    func testPathToSameNode() {
        let finder = PathFinder(nodes: simpleGraph)
        XCTAssertEqual(finder.getShortestPath(from: "A", to: "A"), ["A"])
    }
    
    func testSimpleGraph() {
        let finder = PathFinder(nodes: simpleGraph)
        XCTAssertEqual(finder.getShortestPath(from: "A", to: "G"), ["A", "B", "D", "E", "G"])
    }
    
    func testNoConnection() {
        simpleGraph["H"] = [:]
        let finder = PathFinder(nodes: simpleGraph)
        XCTAssertEqual(finder.getShortestPath(from: "A", to: "H"), [])
    }
}
