import XCTest
@testable import PathFinder

final class PathTests: XCTestCase {
    func testEquatable() {
        XCTAssertEqual(Path(), Path())
        XCTAssertEqual(Path(nodes: ["A"], cost: 1), Path(nodes: ["A"], cost: 1))
        XCTAssertNotEqual(Path(nodes: ["A"], cost: 1), Path(nodes: ["A"], cost: 2))
        XCTAssertNotEqual(Path(nodes: ["A"], cost: 1), Path(nodes: ["B"], cost: 1))
    }
    
    func testInitFrom() {
        let path = Path(nodes: ["A"], cost: 1)
        let newPath = Path(from: path, node: "B", cost: 2)
        XCTAssertEqual(newPath, Path(nodes: ["A", "B"], cost: 3))
    }
}

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
        XCTAssertEqual(finder.getShortestPath(from: "0", to: "A"), Path())
        XCTAssertEqual(finder.getShortestPath(from: "A", to: "0"), Path())
    }
    
    func testPathToSameNode() {
        let finder = PathFinder(nodes: simpleGraph)
        XCTAssertEqual(finder.getShortestPath(from: "A", to: "A"), Path(nodes: ["A"], cost: 0))
    }
    
    func testSimpleGraph() {
        let finder = PathFinder(nodes: simpleGraph)
        XCTAssertEqual(finder.getShortestPath(from: "A", to: "G"), Path(nodes: ["A", "B", "D", "E", "G"], cost: 19))
    }
    
    func testNoConnection() {
        simpleGraph["H"] = [:]
        let finder = PathFinder(nodes: simpleGraph)
        XCTAssertEqual(finder.getShortestPath(from: "A", to: "H"), Path())
    }
}
