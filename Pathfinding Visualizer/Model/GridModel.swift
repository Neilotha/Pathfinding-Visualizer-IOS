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
    var upDatedNodeList: [NodeInfo] = []
    var maxColumn: Int
    var maxRow: Int
    let nodeSize: CGFloat = 30
    var lastUpdatedNode = (row: -1, column: -1)
    
    
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
    
//    appends the updated node's information (row, column, state) to the updatedNodeList for the grid controller to update its views
    func updateNode(row: Int, column: Int, state: NodeState) {
        self.upDatedNodeList.append(NodeInfo(row: row, column: column, state: state))
    }
    
    func resetUpdatedNodeList() {
        self.upDatedNodeList = []
    }
    
    func endAction() {
        self.lastUpdatedNode = (-1, -1)
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
