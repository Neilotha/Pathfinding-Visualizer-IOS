//
//  Dijkstra.swift
//  Pathfinding Visualizer
//
//  Created by Joshua Yang on 2022/8/16.
//

import Foundation
import SwiftUI


func dijkstra(grid: inout [[Node]]) -> (visitedNodes: [Node], shortestPath: [Node]?) {
//    stores the nodes in visited order
    var visitedNodes: [Node] = []
    var finishSearch = false
    var foundShortestPath = false
    var unvisitedNodes = MinPriorityQueue()
    var shortestPath: [Node]?
    let startIndex = findStart(grid: grid)
    
    prepareGrid(grid: &grid)
//    set start node's distance to 0
    grid[startIndex.row][startIndex.column].distance = 0
    
//    push the startNode into the min priority queue
    unvisitedNodes.heap.append(grid[startIndex.row][startIndex.column])
    
//    the loop stops when 1: found the shortest path to destination
//                        2: rhere is no way to reach the finish
    while !finishSearch {
//        if the distance of the current node is max, it means that we are traped and there is no way of reaching the destination
        if unvisitedNodes.heap.count == 0 {
            finishSearch = true
        }
//        put the current node into visited node set
        else {
            let currentNode = unvisitedNodes.extractMin()
            let currentIndex = currentNode.getIndex()
            grid[currentIndex.row][currentIndex.column].visite()
            if currentNode.getState() == .destination(true) || currentNode.getState() == .destination(false) {
                finishSearch = true
                foundShortestPath = true
            }
            else {
                visitedNodes.append(currentNode)
//                update the adjacent nodes
                updateAdjacentNodes(grid: &grid, currentNode: currentNode, minQueue: &unvisitedNodes)
            }
            
        }
        
    }
    
//    find the shortest path
    if foundShortestPath {
        shortestPath = []
        let (row, col) = findDestination(grid: grid)
        var currentNode = grid[row][col]
        shortestPath?.append(currentNode)
        
        while let currentNodeIndex = currentNode.previousNode {
            currentNode = grid[currentNodeIndex.row][currentNodeIndex.column]
            shortestPath?.insert(currentNode, at: 0)
        }
        
        shortestPath?.popLast()
        shortestPath?.removeFirst()
        
    }
    visitedNodes.removeFirst()

    
    return (visitedNodes, shortestPath)
}



// update the current node's unvisited neighbors
func updateAdjacentNodes(grid: inout [[Node]], currentNode: Node, minQueue: inout MinPriorityQueue) {
    let unvisitedAdjacentNodes = getAdjacentNodes(grid: grid, of: currentNode.getIndex())
    var unvisitedIndexList: [(row: Int, column: Int)] = []
    
    for adjacentNode in unvisitedAdjacentNodes {
        unvisitedIndexList.append(adjacentNode.getIndex())
    }
    
    for index in unvisitedIndexList {
//        calculate the adjacentNode's distance through currentNode
        let newDistance = currentNode.distance + 1
        
        if newDistance < grid[index.row][index.column].distance {
            //        update Adjacent node's previous node to current node
            grid[index.row][index.column].previousNode = currentNode.getIndex()
            if !grid[index.row][index.column].inQueue {
                grid[index.row][index.column].distance = newDistance
                minQueue.inert(grid[index.row][index.column])
            }
            else {
                minQueue.changePriority(minQueue.getIndex(of: grid[index.row][index.column]), newDistance)
                syncGridandQueue(grid: &grid, queue: minQueue)
            }
        }
    }
    
    
}


// get the unvisited adjacent nodes of the given node
func getAdjacentNodes(grid: [[Node]], of index: (row: Int, column: Int)) -> [Node] {
    var neighborNodes:[Node] = []
//    get the neighbor to the right
    if index.column < grid[0].count - 1 {
        if grid[index.row][index.column + 1].getState() != .visited && grid[index.row][index.column + 1].getState() != .wall {
            neighborNodes.append(grid[index.row][index.column + 1])
        }
    }
//    get the neighbor to the left
    if index.column > 0 {
        if grid[index.row][index.column - 1].getState() != .visited && grid[index.row][index.column - 1].getState() != .wall {
            neighborNodes.append(grid[index.row][index.column - 1])
        }
    }
//    get the neighbor to the top
    if index.row > 0 {
        if grid[index.row - 1][index.column].getState() != .visited && grid[index.row - 1][index.column].getState() != .wall {
            neighborNodes.append(grid[index.row - 1][index.column])
        }
    }
//    get the neighbor to the bottom
    if index.row < grid.count - 1 {
        if grid[index.row + 1][index.column].getState() != .visited && grid[index.row + 1][index.column].getState() != .wall {
            neighborNodes.append(grid[index.row + 1][index.column])
        }
    }
    
    return neighborNodes
    
}

func findStart(grid: [[Node]]) -> (row: Int, column: Int) {
    var start = (-1, -1)
    for row in 0 ..< grid.count {
        for column in 0 ..< grid[0].count {
            if grid[row][column].getState() == .start(false) || grid[row][column].getState() == .start(true) {
                start = (row: row, column: column)
            }
        }
    }
    
    return start
}

func findDestination(grid: [[Node]]) -> (row: Int, column: Int) {
    var destination = (-1, -1)
    for row in 0 ..< grid.count {
        for column in 0 ..< grid[0].count {
            if grid[row][column].getState() == .destination(false) || grid[row][column].getState() == .destination(true) {
                destination = (row: row, column: column)
            }
        }
    }
    
    return destination
}

// Initialize distance and inqueue property of all nodes
func prepareGrid(grid: inout [[Node]]) {
    for row in 0 ..< grid.count {
        for column in 0 ..< grid[0].count {
            grid[row][column].distance = Int.max
            grid[row][column].inQueue = false
            grid[row][column].previousNode = nil
        }
    }

}

func syncGridandQueue(grid: inout [[Node]], queue: MinPriorityQueue) {
    for node in queue.heap {
        let index = node.getIndex()
        grid[index.row][index.column] = node
    }
}
