//
//  GridView.swift
//  Pathfinding Visualizer
//
//  Created by Joshua Yang on 2022/8/12.
//

import SwiftUI

struct GridView: UIViewRepresentable {
    @ObservedObject var model: GridModel
    let height: Int
    let width: Int
    
    
    func makeUIView(context: Context) -> GridController {
        model.updateModel(height: height, width: width)
        let view = GridController(grid: model.grid, maxColumn: model.maxColumn, maxRow: model.maxRow, nodeSize: model.nodeSize, dragCallBack: model.wallAction(row:column:), endDragCallBack: model.endAction)
        
        return view
    }
    
    func updateUIView(_ uiView: GridController, context: Context) {
        print("UIView update triggered!")
        uiView.grid = model.grid
        uiView.updatedNodes = model.upDatedNodeList
        uiView.setNeedsDisplay()
        model.resetUpdatedNodeList()

    }
}
