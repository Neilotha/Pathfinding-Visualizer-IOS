//
//  GridModel.swift
//  Pathfinding Visualizer
//
//  Created by Joshua Yang on 2022/8/12.
//

import Foundation
import SwiftUI

class GridModel: ObservableObject {
    @Published var grid: [[Node]]
    @Published var nodeNeedAnimate: Bool = false
    var upDatedNodeList: [NodeInfo] = []
    var maxColumn: Int
    var maxRow: Int
    let nodeSize: CGFloat = 20
    var lastUpdatedNode = (row: -1, column: -1)
    var draggingNode: Bool = false
    var drawingWall: Bool = false
    var searched: Bool = false
    
    
//    initialize the grid with maxRow and maxColumn
    init(height: Int, width: Int) {
        self.maxColumn = width / Int(nodeSize)
        self.maxRow = height / Int(nodeSize)
        self.grid = [[Node]](
            repeating: [Node](repeating: Node(as: .empty, index: (0, 0)), count: maxColumn),
            count: maxRow)

        for row in 0 ..< maxRow {
            for column in 0 ..< maxColumn {
                self.grid[row][column] = Node(as: .empty, index: (row, column))
            }
        }
        
//        placing start and destination node
        self.grid[maxRow/2][maxColumn/3] = Node(as: .start(false), index: (maxRow/2, maxColumn/3))
        self.grid[maxRow/2][(maxColumn/3) * 2] = Node(as: .destination(false), index: (maxRow/2, (maxColumn/3) * 2))
    }
    
    func updateModel(height: Int, width: Int) {
        self.maxColumn = width / Int(nodeSize)
        self.maxRow = height / Int(nodeSize)
        self.grid = [[Node]](
            repeating: [Node](repeating: Node(as: .empty, index: (0, 0)), count: maxColumn),
            count: maxRow)

        for row in 0 ..< maxRow {
            for column in 0 ..< maxColumn {
                self.grid[row][column] = Node(as: .empty, index: (row, column))
            }
        }
        
//        placing start and destination node
        self.grid[maxRow/2][maxColumn/3] = Node(as: .start(false), index: (maxRow/2, maxColumn/3))
        self.grid[maxRow/2][(maxColumn/3) * 2] = Node(as: .destination(false), index: (maxRow/2, (maxColumn/3) * 2))
    }
    
    func wallAction(row: Int, column: Int) {
        if row != lastUpdatedNode.row || column != lastUpdatedNode.column {
            grid[row][column].toggleWall()
            lastUpdatedNode = (row, column)
            updateNode(row: row, column: column, state: grid[row][column].getState())
            print("node: [\(row), \(column)] trigger dected!")
        }
        else {
//            print("node: [\(row), \(column)]duplicate trigger dected!")
        }
    }
    

    
//    function for handling grid input, its purpose is to determine if the user is drawing a wall or dragging star/destinaion node
    func handleGridInput(row: Int, column: Int) {
        guard row != lastUpdatedNode.row || column != lastUpdatedNode.column else { return }
        
        if draggingNode {
            switch grid[lastUpdatedNode.row][lastUpdatedNode.column].getState() {
            case .start:
                guard grid[row][column].getState() != .destination(true) && grid[row][column].getState() != .destination(false)  else { return }
                grid[lastUpdatedNode.row][lastUpdatedNode.column].toggleStart()
                grid[row][column].toggleStart()
                
                updateNode(row: lastUpdatedNode.row, column: lastUpdatedNode.column, state: grid[lastUpdatedNode.row][lastUpdatedNode.column].getState())
                
                updateNode(row: row, column: column, state: grid[row][column].getState())
                lastUpdatedNode = (row, column)
                
//                instant render pathfinding algorithm if is searched
                if self.searched {
                    handleDijkstra()
                }
            case .destination:
                guard grid[row][column].getState() != .start(true) && grid[row][column].getState() != .start(false)  else { return }
                grid[lastUpdatedNode.row][lastUpdatedNode.column].toggleDestination()
                grid[row][column].toggleDestination()
                
                updateNode(row: lastUpdatedNode.row, column: lastUpdatedNode.column, state: grid[lastUpdatedNode.row][lastUpdatedNode.column].getState())
                
                updateNode(row: row, column: column, state: grid[row][column].getState())
                lastUpdatedNode = (row, column)
                
                
//                instant render pathfinding algorithm if is searched
                if self.searched {
                    handleDijkstra()
                }
            default:
                break
            }
            
            
        }
        else if drawingWall {
            grid[row][column].toggleWall()
            lastUpdatedNode = (row, column)
            updateNode(row: row, column: column, state: grid[row][column].getState())
        }
        else {
            switch grid[row][column].getState() {
            case .start, .destination:
                print("start dragging")
                draggingNode = true
                lastUpdatedNode = (row, column)
            default:
                drawingWall = true
            }
        }
    }
    
    func handleClearGrid() {
        for row in 0 ..< maxRow {
            for column in 0 ..< maxColumn {
                if (row == maxRow/2 && column == maxColumn/3) {
                    //        placing start node
                    self.grid[maxRow/2][maxColumn/3].nodeState = .start(false)
                    updateNode(row: row, column: column, state: .start(false))
                }
                else if (row == maxRow/2 && column == maxColumn/3 * 2) {
                    //        placing destination node
                    self.grid[maxRow/2][(maxColumn/3) * 2].nodeState = .destination(false)
                    updateNode(row: row, column: column, state: .destination(false))
                }
                else {
                    self.grid[row][column].nodeState = .empty
                    updateNode(row: row, column: column, state: .empty)
                }
            }
        }
        
        searched = false
        
    }
    
    func handleClearWall() {
        for row in 0 ..< maxRow {
            for column in 0 ..< maxColumn {
                if grid[row][column].getState() == .wall || grid[row][column].getState() == .visited || grid[row][column].getState() == .path  {
                    grid[row][column].nodeState = .empty
                    updateNode(row: row, column: column, state: .empty)
                }
            }
        }
        
        searched = false
    }
    
    func clearSearch() {
        for row in 0 ..< maxRow {
            for column in 0 ..< maxColumn {
                if grid[row][column].getState() == .visited || grid[row][column].getState() == .path {
                    grid[row][column].nodeState = .empty
                    updateNode(row: row, column: column, state: .empty)
                }
            }
        }
        self.nodeNeedAnimate.toggle()
    }
    
    func handleDijkstra() {
        self.clearSearch()
        let result = dijkstra(grid: &grid)
//        for visitNode in result.visitedNodes {
//            let index = visitNode.getIndex()
//            updateNode(row: index.row, column: index.column, state: visitNode.getState())
//        }
        
        if !searched {
            animateSearch(result: result)
            searched = true
        }
        else {
            for visitNode in result.visitedNodes {
                let index = visitNode.getIndex()
                updateNode(row: index.row, column: index.column, state: .visited)
            }
                
            if let path = result.shortestPath {
                for node in path {
                    let index = node.getIndex()
                    updateNode(row: index.row, column: index.column, state: .path)
                }
            }
            
            searched = true
        }
        
//        if let path = result.shortestPath {
//            for node in path {
//                let index = node.getIndex()
//                updateNode(row: index.row, column: index.column, state: .path)
//            }
//        }
    }
    
    func animateSearch(result: (visitedNodes: [Node], shortestPath: [Node]?)) {
        var i = 0
        var p = 0
        _ = Timer.scheduledTimer(withTimeInterval: 0.008, repeats: true) { timer in
            if i < result.visitedNodes.count {
                let index = result.visitedNodes[i].getIndex()
                self.updateNode(row: index.row , column: index.column, state: .visited)
                self.nodeNeedAnimate.toggle()
                i += 1
            }
            else {
                if let path = result.shortestPath {
                    if p < path.count {
                        let index = path[p].getIndex()
                        self.updateNode(row: index.row , column: index.column, state: .path)
                        self.nodeNeedAnimate.toggle()
                        p += 1
                    }
                    else {
                        timer.invalidate()
                    }
                }
            }
        }
        
//        if let path = result.shortestPath {
//            _ = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
//                if p < path.count {
//                    let index = path[p].getIndex()
//                    self.updateNode(row: index.row , column: index.column, state: .path)
//                    self.nodeNeedAnimate.toggle()
//                    p += 1
//                }
//                else {
//                    timer.invalidate()
//                }
//            }
//        }
        
        
//        var timeOffest = 0.0
//        for node in result.visitedNodes {
//            timeOffest += 0.005
//            DispatchQueue.main.asyncAfter(deadline: .now() + timeOffest) {
//                let index = node.getIndex()
//                self.updateNode(row: index.row , column: index.column, state: .visited)
//                self.nodeNeedAnimate.toggle()
//            }
//        }
        
//        if let path = result.shortestPath {
//            for node in path {
//                timeOffest += 0.05
//                DispatchQueue.main.asyncAfter(deadline: .now() + timeOffest) {
//                    let index = node.getIndex()
//                    self.updateNode(row: index.row, column: index.column, state: .path)
//                    self.nodeNeedAnimate.toggle()
//                }
//            }
//        }
    }
//    appends the updated node's information (row, column, state) to the updatedNodeList for the grid controller to update its views
    func updateNode(row: Int, column: Int, state: NodeState) {
        self.upDatedNodeList.append(NodeInfo(row: row, column: column, state: state))
    }
    
    func resetUpdatedNodeList() {
        self.upDatedNodeList = []
    }
    
    func endAction() {
        self.lastUpdatedNode = (-1, -1)
        self.draggingNode = false
        self.drawingWall = false
    }
    
}

struct NodeInfo {
    var column: Int
    var row: Int
    var state: NodeState
    
    init(row: Int, column: Int, state: NodeState ) {
        self.column = column
        self.row = row
        self.state = state
    }
}
