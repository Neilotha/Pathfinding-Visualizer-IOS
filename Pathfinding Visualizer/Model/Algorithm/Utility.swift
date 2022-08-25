//
//  Utility.swift
//  Pathfinding Visualizer
//
//  Created by Joshua Yang on 2022/8/24.
//

import Foundation

func findStart(grid: [[Node]]) -> Node {
    var start: Node = grid[0][0]
    for row in 0 ..< grid.count {
        for column in 0 ..< grid[0].count {
            if case .start = grid[row][column].nodeState {
                start = grid[row][column]
            }
        }
    }
    
    return start
}

func findDestination(grid: [[Node]]) -> Node {
    var destination: Node = grid[0][0]
    for row in 0 ..< grid.count {
        for column in 0 ..< grid[0].count {
            if case .destination = grid[row][column].nodeState {
                destination = grid[row][column]
            }
        }
    }
    
    return destination
}

func findShortestPath(destination: Node) -> [Node] {
    var shortestPath: [Node] = []
    var doneBackTrack = false
    var currentNode = destination.previousNode!
    
    while !doneBackTrack {
        if case .start = currentNode.nodeState { doneBackTrack = true }
        else {
            shortestPath.append(currentNode)
            currentNode = currentNode.previousNode!
        }
        
    }
    
    shortestPath.reverse()
    
    return shortestPath
}

// get the adjacent nodes of the given node
func getAdjacentNodes(grid: [[Node]], of node: Node, filterVisited: Bool) -> [Node] {
    var neighborNodes:[Node] = []
//    get the neighbor to the right
    if node.column < grid[0].count - 1 {
        if grid[node.row][node.column + 1].nodeState != .wall {
            if !(filterVisited && grid[node.row][node.column + 1].nodeState == .visited) {
                neighborNodes.append(grid[node.row][node.column + 1])
            }
        }
    }
//    get the neighbor to the left
    if node.column > 0 {
        if grid[node.row][node.column - 1].nodeState != .wall {
            if !(filterVisited && grid[node.row][node.column - 1].nodeState == .visited) {
                neighborNodes.append(grid[node.row][node.column - 1])
            }
        }
    }
//    get the neighbor to the top
    if node.row > 0 {
        if grid[node.row - 1][node.column].nodeState != .wall {
            if !(filterVisited && grid[node.row - 1][node.column].nodeState == .visited) {
                neighborNodes.append(grid[node.row - 1][node.column])
            }
        }
    }
//    get the neighbor to the bottom
    if node.row < grid.count - 1 {
        if grid[node.row + 1][node.column].nodeState != .wall {
            if !(filterVisited && grid[node.row + 1][node.column].nodeState == .visited) {
                neighborNodes.append(grid[node.row + 1][node.column])
            }
        }
    }
    
    return neighborNodes
    
}
