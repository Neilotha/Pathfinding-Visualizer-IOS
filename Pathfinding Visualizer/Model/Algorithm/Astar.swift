//
//  Astar.swift
//  Pathfinding Visualizer
//
//  Created by Joshua Yang on 2022/8/19.
//

import Foundation

func aStar(grid: [[Node]]) -> (visitedNodes: [Node], shortestPath: [Node]?) {
    var openList = MinPriorityQueue(priorityFunction: aStarPriorityFunction)
    var closedList: [Node] = []
    var visitedNodes: [Node] = []
    var shortestPath: [Node]?
    let startNode = findStart(grid: grid)
    let destinationNode = findDestination(grid: grid)
    var foundShortestPath = false
    
    prepareGrid(grid: grid)
    
//    set the start node's priority
    startNode.priorityInfo = aStarPriority(distance: 0, heuristic: 0)
    openList.insert(startNode)
    
    while openList.heap.count > 0 && !foundShortestPath {
//        Find the node with the highest priority and pop it
        let currentNode = openList.extractMin()
        
        
//        Push currentNode into the closedList
        closedList.append(currentNode)
//        If the currentNode is the destination, stop the search
        if case .destination = currentNode.nodeState { foundShortestPath = true }
        else {
            visitedNodes.append(currentNode)
            currentNode.visite()
            
//            find the current node's neighbors
            let neighborNodes = getAdjacentNodes(grid: grid, of: currentNode, filterVisited: false)
            for neighbor in neighborNodes {
//                calculate distance and heuristic of the neighbor passing through currentNode
                let neighborCurrentPriority = neighbor.priorityInfo as! aStarPriority
                let newNeighborPriority = calculatePriority(of: neighbor, through: currentNode, destination: destinationNode)
//                if the new path to neighbor has shorter distance than it's previous path
                if newNeighborPriority.distance < neighborCurrentPriority.distance {
                    if closedList.contains(neighbor) {
                        neighbor.priorityInfo = newNeighborPriority
                        neighbor.previousNode = currentNode
                    }
                    else if neighbor.inQueue {
    //                  update the neighbor's priority and set its parent to currentNode
                        openList.changePriority(openList.getIndex(of: neighbor), newNeighborPriority)
                        neighbor.previousNode = currentNode
                    }
        //                if the neighbor isn't in both list
                    else if !closedList.contains(neighbor) && !neighbor.inQueue {
        //                    add it to the open list and set its priority
                        neighbor.priorityInfo = newNeighborPriority
                        neighbor.previousNode = currentNode
                        openList.insert(neighbor)
                    }
                }
            }
        }
        
        
    }
    
//    find the shortest path
    if foundShortestPath {
        shortestPath = findShortestPath(destination: destinationNode)
    }
    
    visitedNodes.removeFirst()

        
    return (visitedNodes, shortestPath)
    
    
}

fileprivate struct aStarPriority: PriorityInfoProtocol {
    var distance: Int
    var heuristic: Int
    
    init(distance: Int, heuristic: Int) {
        self.distance = distance
        self.heuristic = heuristic
    }
    
}

//  returns true if the priority of priority1 is higher than priority2
fileprivate func aStarPriorityFunction( priority1: PriorityInfoProtocol, priority2: PriorityInfoProtocol) -> Bool {
    let p1 = priority1 as! aStarPriority
    let p2 = priority2 as! aStarPriority
    var result = false
    if p1.distance + p1.heuristic < p2.distance + p2.heuristic { result = true }
    else if p1.distance + p1.heuristic == p2.distance + p2.heuristic {
        if p1.heuristic < p2.heuristic { result = true }
    }
    
    return result
}


// Initialize priority and inqueue property of all nodes
fileprivate func prepareGrid(grid: [[Node]]) {
    for row in 0 ..< grid.count {
        for column in 0 ..< grid[0].count {
            grid[row][column].priorityInfo = aStarPriority(distance: Int.max/3, heuristic: Int.max/3)
            grid[row][column].inQueue = false
            grid[row][column].previousNode = nil
        }
    }

}

// calculate the distance and heuristic value of a node
fileprivate func calculatePriority(of node1: Node, through node2: Node, destination: Node) -> aStarPriority {
    let distance = node2.priorityInfo!.distance + 1
    let heuristic = abs(node1.row - destination.row) + abs(node1.column - destination.column)
    
    return aStarPriority(distance: distance, heuristic: heuristic)
}


