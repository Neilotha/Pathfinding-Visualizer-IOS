//
//  Dijkstra.swift
//  Pathfinding Visualizer
//
//  Created by Joshua Yang on 2022/8/16.
//

import Foundation
import SwiftUI


func dijkstra(grid: [[Node]]) -> (visitedNodes: [Node], shortestPath: [Node]?) {
//    stores the nodes in visited order
    var visitedNodes: [Node] = []
    var finishSearch = false
    var foundShortestPath = false
    var unvisitedNodes = MinPriorityQueue(priorityFunction: diijkstraPriorityFunction)
    var shortestPath: [Node]?
    let startNode = findStart(grid: grid)
    
    prepareGrid(grid: grid)
//    set start node's distance to 0
    grid[startNode.row][startNode.column].priorityInfo!.distance = 0
    
//    push the startNode into the min priority queue
    unvisitedNodes.heap.append(grid[startNode.row][startNode.column])
    
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
            currentNode.visite()
            
            if case .destination = currentNode.nodeState {
                finishSearch = true
                foundShortestPath = true
            }
            else {
                visitedNodes.append(currentNode)
//                update the adjacent nodes
                updateAdjacentNodes(grid: grid, currentNode: currentNode, minQueue: &unvisitedNodes)
            }
            
        }
        
    }
    
//    find the shortest path
    if foundShortestPath {
        shortestPath = findShortestPath(destination: findDestination(grid: grid))
        
    }
    visitedNodes.removeFirst()

    
    return (visitedNodes, shortestPath)
}


fileprivate struct diijkstraPriority: PriorityInfoProtocol {
    var distance: Int
    
    init(distance: Int) {
        self.distance = distance
    }
    
}

//  returns true if the priority of priority1 is higher than priority2
fileprivate func diijkstraPriorityFunction( priority1: PriorityInfoProtocol, priority2: PriorityInfoProtocol) -> Bool {
    let p1 = priority1 as! diijkstraPriority
    let p2 = priority2 as! diijkstraPriority
    var result = false
    if p1.distance < p2.distance { result = true }
    
    return result
}

// update the current node's unvisited neighbors
fileprivate func updateAdjacentNodes(grid: [[Node]], currentNode: Node, minQueue: inout MinPriorityQueue) {
    let unvisitedAdjacentNodes = getAdjacentNodes(grid: grid, of: currentNode, filterVisited: true)

    for node in unvisitedAdjacentNodes {
//        calculate the adjacentNode's distance through currentNode
        var newPriority = currentNode.priorityInfo as! diijkstraPriority
        newPriority.distance += 1
        
        if diijkstraPriorityFunction(priority1: newPriority, priority2: node.priorityInfo!) {
            //        update Adjacent node's previous node to current node
            node.previousNode = currentNode
            if !node.inQueue {
                node.priorityInfo = newPriority
                minQueue.insert(node)
            }
            else {
                minQueue.changePriority(minQueue.getIndex(of: node), newPriority)
            }
        }
    }
}


// Initialize priority and inqueue property of all nodes
fileprivate func prepareGrid(grid: [[Node]]) {
    for row in 0 ..< grid.count {
        for column in 0 ..< grid[0].count {
            grid[row][column].priorityInfo = diijkstraPriority(distance: Int.max)
            grid[row][column].inQueue = false
            grid[row][column].previousNode = nil
        }
    }

}

