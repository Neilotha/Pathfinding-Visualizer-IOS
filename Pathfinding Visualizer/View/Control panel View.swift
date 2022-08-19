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
            
            Button("Dijkstra") {
                model.searched = false
                model.handleDijkstra()
            }
            
            Spacer()
            
            Button("Reset Board") {
                model.handleClearGrid()
            }
            
            Spacer()
            
            Button("Clear Wall") {
                model.handleClearWall()
            }
            
            Spacer()
        }
    }
}

struct Control_panel_View_Previews: PreviewProvider {
    static var previews: some View {
        Control_panel_View(model: GridModel(height: 30, width: 30))
    }
}
