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
        let view = GridController(maxColumn: model.maxColumn,
                                  maxRow: model.maxRow,
                                  nodeSize: model.nodeSize,
                                  nodeViewList: model.updatedNodeList,
                                  dragCallBack: model.handleGridInput(row:column:),
                                  endDragCallBack: model.endAction,
                                  resetNodeListCallBack: model.resetUpdatedNodeList)
        
        return view
    }
    
    func updateUIView(_ uiView: GridController, context: Context) {
        uiView.updatedNodes = model.updatedNodeList
        if model.redrawGrid {
            uiView.clear()
            uiView.maxRow = model.maxRow
            uiView.maxColumn = model.maxColumn
            uiView.redrawView(redrawGrid: &model.redrawGrid)
            uiView.setNeedsDisplay()
        }
        else if model.updatedNodeList.count > 0 {
            uiView.setNeedsDisplay()
        }


    }
}
