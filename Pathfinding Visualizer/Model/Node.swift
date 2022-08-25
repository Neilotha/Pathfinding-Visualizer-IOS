//
//  Node.swift
//  Pathfinding Visualizer
//
//  Created by Joshua Yang on 2022/8/12.
//

import Foundation

enum NodeState: Equatable {
    case empty
    case start(Bool)
    case destination(Bool)
    case wall
    case visited
    case path
}



// additional node info for path finding algorithm (may vary between algorithm)
protocol PriorityInfoProtocol {
    var distance: Int { set get }
}

class Node: Equatable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.row == rhs.row && lhs.column == rhs.column
    }
    
    var nodeState: NodeState
    let row: Int
    let column: Int
    var inQueue: Bool = false
    var previousNode: Node?
    var priorityInfo: PriorityInfoProtocol?
    
    init(as state: NodeState, coordinate: (Int, Int)) {
        self.nodeState = state
        (self.row, self.column) = coordinate
    }
    
    func toggleWall() {
        switch self.nodeState {
        case .empty, .visited:
            self.nodeState = .wall
        case .wall:
            self.nodeState = .empty
        default:
            break
        }
        
//        print("node: [\(row), \(column)] triggered")
    }
    
    func toggleStart() {
        switch self.nodeState {
        // Toggling start node to none-start nodes (empty node or wall node)
        case .start(let wasWall):
            if wasWall { self.nodeState = .wall }
            else { self.nodeState = .empty }
        // Toggling none start nodes to start nodes
        case .wall:
            self.nodeState = .start(true)
        default:
            self.nodeState = .start(false)
        }
    }
    
    func toggleDestination() {
        switch self.nodeState {
        // Toggling destination node to none-destination nodes (empty node or wall node)
        case .destination(let wasWall):
            if wasWall { self.nodeState = .wall }
            else { self.nodeState = .empty }
        // Toggling none destination nodes to destination nodes
        case .wall:
            self.nodeState = .destination(true)
        default:
            self.nodeState = .destination(false)
        }
    }
    
    func visite() {
        switch self.nodeState {
        case .start, .destination:
            return
        default:
            self.nodeState = .visited
        }
        
    }
    
    
    
    
}
