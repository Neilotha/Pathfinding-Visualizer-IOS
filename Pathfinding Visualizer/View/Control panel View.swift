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
            Stats(model: model)
            
            Spacer()
            Button("Reset!") {
                model.searched = false
                model.clearGrid()
            }
            .font(.system(size: 15))
            .padding()
            .background(.blue)
            .cornerRadius(9)
            .foregroundColor(.white)
            
            Spacer()
            Algorithm_Picker(model: model)
            Spacer()

        }
    }
}

struct Control_panel_View_Previews: PreviewProvider {
    static var previews: some View {
        Control_panel_View(model: GridModel())
    }
}
