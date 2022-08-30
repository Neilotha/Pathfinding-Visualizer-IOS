//
//  GridModel.swift
//  Pathfinding Visualizer
//
//  Created by Joshua Yang on 2022/8/12.
//

import Foundation
import SwiftUI

class GridModel: ObservableObject {
    @Published var viewNeedUpdate: Bool = false
    var grid: [[Node]] = []
    var updatedNodeList: [(row: Int, column: Int, state: NodeState)] = []
    var maxColumn: Int = 0
    var maxRow: Int = 0
    let nodeSize: CGFloat = 20
    var currentAlgorithm: (([[Node]]) -> (visitedNodes: [Node], shortestPath: [Node]?))?
    var searched: Bool = false
    var playingAnimation = false
    var inputState: InputState
    var lastUpdatedNode = (row: -1, column: -1)
    
    
    
    init() {
        self.grid = []
        inputState = InputState.none
        currentAlgorithm = dijkstra
    }
    
    func updateModel(height: Int, width: Int) {
        self.lastUpdatedNode = (row: -1, column: -1)
        self.searched = false
        self.playingAnimation = false
        self.maxColumn = width / Int(nodeSize)
        self.maxRow = height / Int(nodeSize)
        self.grid = [[Node]](
            repeating: [Node](repeating: Node(as: .empty, coordinate: (0, 0)), count: maxColumn),
            count: maxRow)

        for row in 0 ..< maxRow {
            for column in 0 ..< maxColumn {
                self.grid[row][column] = Node(as: .empty, coordinate: (row, column))
            }
        }
        
//        placing start and destination node
        self.grid[maxRow/5][maxColumn/2] = Node(as: .start(false), coordinate: (maxRow/5, maxColumn/2))
        self.grid[maxRow/5 * 4][(maxColumn/2)] = Node(as: .destination(false), coordinate: (maxRow/5 * 4, maxColumn/2))
        
//        notify the view to draw the grid
        for row in 0 ..< maxRow {
            for column in 0 ..< maxColumn {
                updateNodeView(row: row, column: column, state: grid[row][column].nodeState)
            }
        }
        
        viewNeedUpdate.toggle()
    }
    
    

    
//    function for handling grid input, its purpose is to determine if the user is drawing a wall or dragging star/destinaion node
    func handleGridInput(row: Int, column: Int) {
        guard !playingAnimation else { return }
        guard row != lastUpdatedNode.row || column != lastUpdatedNode.column else { return }
        
        switch self.inputState {
        case .dragging:
            switch grid[lastUpdatedNode.row][lastUpdatedNode.column].nodeState {
            case .start:
                if case .destination = grid[row][column].nodeState { return }
                grid[lastUpdatedNode.row][lastUpdatedNode.column].toggleStart()
                grid[row][column].toggleStart()
                
                updateNodeView(row: lastUpdatedNode.row, column: lastUpdatedNode.column, state: grid[lastUpdatedNode.row][lastUpdatedNode.column].nodeState)
                lastUpdatedNode = (row, column)
                updateNodeView(row: row, column: column, state: grid[row][column].nodeState)
                self.viewNeedUpdate.toggle()
                
//                instant render pathfinding algorithm if is searched
                if self.currentAlgorithm != nil {
                    if searched {
                        visualizeAlgorithm()
                    }
                }
            case .destination:
                if case .start = grid[row][column].nodeState { return }
                grid[lastUpdatedNode.row][lastUpdatedNode.column].toggleDestination()
                grid[row][column].toggleDestination()
                                
                updateNodeView(row: lastUpdatedNode.row, column: lastUpdatedNode.column, state: grid[lastUpdatedNode.row][lastUpdatedNode.column].nodeState)
                lastUpdatedNode = (row, column)
                updateNodeView(row: row, column: column, state: grid[row][column].nodeState)
                self.viewNeedUpdate.toggle()
                
//                instant render pathfinding algorithm if is searched
                if self.currentAlgorithm != nil {
                    if searched {
                        visualizeAlgorithm()
                    }
                }
            default:
                break
            }
            
        case .drawing:
            grid[row][column].toggleWall()
            lastUpdatedNode = (row, column)
            updateNodeView(row: row, column: column, state: grid[row][column].nodeState)
            self.viewNeedUpdate.toggle()
        default:
            switch grid[row][column].nodeState {
            case .start, .destination:
                self.inputState = .dragging
                lastUpdatedNode = (row, column)
            default:
                self.inputState = .drawing
                grid[row][column].toggleWall()
                lastUpdatedNode = (row, column)
                updateNodeView(row: row, column: column, state: grid[row][column].nodeState)
                self.viewNeedUpdate.toggle()
            }
        }
        
    }
    
    func clearGrid() {
        for row in 0 ..< maxRow {
            for column in 0 ..< maxColumn {
                if (row == maxRow/5 && column == maxColumn/2) {
                    //        placing start node
                    self.grid[maxRow/5][maxColumn/2].nodeState = .start(false)
                    updateNodeView(row: row, column: column, state: grid[row][column].nodeState)
                }
                else if (row == maxRow/5 * 4 && column == maxColumn/2) {
                    //        placing destination node
                    self.grid[maxRow/5 * 4][maxColumn/2].nodeState = .destination(false)
                    updateNodeView(row: row, column: column, state: grid[row][column].nodeState)
                }
                else {
                    self.grid[row][column].nodeState = .empty
                    updateNodeView(row: row, column: column, state: grid[row][column].nodeState)
                }
            }
        }
        
        self.searched = false
        
//        notify the view to draw the grid
        viewNeedUpdate.toggle()
        
    }
    
    func clearWall() {
        for row in 0 ..< maxRow {
            for column in 0 ..< maxColumn {
                switch grid[row][column].nodeState {
                case .wall, .visited, .path:
                    grid[row][column].nodeState = .empty
                    updateNodeView(row: row, column: column, state: grid[row][column].nodeState)
                default:
                    continue
                }
            }
        }
        
        self.searched = false
//        notify the view to draw the updated grid
        self.viewNeedUpdate.toggle()
    }
    
    func clearSearch() {
        for row in 0 ..< maxRow {
            for column in 0 ..< maxColumn {
                switch grid[row][column].nodeState {
                case .visited, .path:
                    grid[row][column].nodeState = .empty
                    updateNodeView(row: row, column: column, state: .empty)
                default:
                    continue
                }
            }
        }
        
        self.viewNeedUpdate.toggle()
    }
    
    
//     set the current pathfinding algorithm
    func setAlgorithm(algorithm: @escaping ([[Node]]) -> (visitedNodes: [Node], shortestPath: [Node]?)) {
        self.currentAlgorithm = algorithm
    }
    
//    call the given pathfinding algorithm and visualize the returned result
    func visualizeAlgorithm() {
        clearSearch()
        guard let algorithm = self.currentAlgorithm else {return}
        let result = algorithm(self.grid)
        
        if !searched {
            animateSearch(result: result)
            searched = true
        }
        else {
            for visitedNode in result.visitedNodes {
                updateNodeView(row: visitedNode.row, column: visitedNode.column, state: visitedNode.nodeState)
            }
                
            if let path = result.shortestPath {
                for node in path {
                    updateNodeView(row: node.row, column: node.column, state: .path)
                }
            }
            
            searched = true
            
            self.viewNeedUpdate.toggle()
        }
    }
    
    func animateSearch(result: (visitedNodes: [Node], shortestPath: [Node]?)) {
        var i = 0
        var p = 0
        playingAnimation = true
        _ = Timer.scheduledTimer(withTimeInterval: 0.008, repeats: true) { timer in
            if i < result.visitedNodes.count {
                let node = result.visitedNodes[i]
                self.updateNodeView(row: node.row, column: node.column, state: .visited)
                self.viewNeedUpdate.toggle()
                i += 1
            }
            else {
                if let path = result.shortestPath {
                    if p < path.count {
                        let node = path[p]
                        self.updateNodeView(row: node.row, column: node.column, state: .path)
                        self.viewNeedUpdate.toggle()
                        p += 1
                    }
                    else {
                        timer.invalidate()
                        self.playingAnimation = false
                    }
                }
            }
        }
    }
    
    func updateNodeView(row: Int, column: Int, state: NodeState) {
        self.updatedNodeList.append((row: row, column: column, state: state))
    }
    
    func resetUpdatedNodeList() {
        self.updatedNodeList = []
    }
    
    func endAction() {
        self.lastUpdatedNode = (-1, -1)
        self.inputState = .none
    }
    
}

enum InputState {
    case none
    case dragging
    case drawing
}
