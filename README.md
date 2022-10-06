# SwiftyPathFinder

A swifty, easy-to-use and efficient implementation of **Dijkstra's algorithm** for finding shortest paths.

## Usage

Considering the following (simple) nodes graph:

![Simple Graph Example](https://user-images.githubusercontent.com/93484872/194341251-87e6c59c-0346-4f7b-aa83-debc637123db.png)

To find the shortest path from A to G:

```swift
// Set edges
let edges = [
    Edge(from: "A", to: "B", cost: 2),
    Edge(from: "A", to: "C", cost: 6),
    Edge(from: "B", to: "D", cost: 5),
    Edge(from: "C", to: "D", cost: 3),
    Edge(from: "D", to: "E", cost: 10),
    Edge(from: "D", to: "F", cost: 13),
    Edge(from: "E", to: "G", cost: 2),
    Edge(from: "E", to: "F", cost: 6),
    Edge(from: "F", to: "G", cost: 6)
]

// Initialize a PathFinder
let finder = PathFinder(edges: simpleGraphEdges)

// Find the shortest path
finder.getShortestPath(from: "A", to: "G")
// Returns: Path(nodes: ["A", "B", "D", "E", "G"], cost: 19)
```
