//
//  Control panel View.swift
//  Pathfinding Visualizer
//
//  Created by Joshua Yang on 2022/8/16.
//

import SwiftUI

struct Control_panel_View: View {
    let model: GridModel
    
    var body: some View {
        HStack {
            Spacer()
            
//            Button("Dijkstra") {
//                model.searched = false
//                model.setAlgorithm(algorithm: dijkstra)
//                model.visualizeAlgorithm()
//            }
//
//
//            Button("A*") {
//                model.searched = false
//                model.setAlgorithm(algorithm: aStar)
//                model.visualizeAlgorithm()
//            }
            Algorithm_Picker(model: model)
            
            Spacer()
            
//            Button("Reset Board") {
//                model.searched = false
//                model.clearGrid()
//            }
//
//            Spacer()
//
//            Button("Clear Wall") {
//                model.clearWall()
//            }
//
//            Spacer()
//
//            Button("Clear Search") {
//                model.clearSearch()
//            }
            Clear_Grid_Picker(model: model)
            
            Spacer()
        }
    }
}

struct Control_panel_View_Previews: PreviewProvider {
    static var previews: some View {
        Control_panel_View(model: GridModel())
    }
}
