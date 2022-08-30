//
//  Clear Grid Picker.swift
//  Pathfinding Visualizer
//
//  Created by Joshua Yang on 2022/8/30.
//

import SwiftUI

enum Actions {
    case clearWall
    case clearSearch
    case resetBoard
}

struct Clear_Grid_Picker: View {
    @State private var selectedAction = Actions.clearWall
    var model: GridModel
    
    
    var body: some View {
        HStack {
            Picker("Algorithm:", selection: $selectedAction) {
                Text("Clear Wall")
                    .tag(Actions.clearWall)
                Text("Clear Search")
                    .tag(Actions.clearSearch)
                Text("Reset Board")
                    .tag(Actions.resetBoard)
            }
            .pickerStyle(.menu)
            
            Button("Execute!") {
                switch selectedAction {
                case .clearWall:
                    model.clearWall()
                case .clearSearch:
                    model.clearSearch()
                case .resetBoard:
                    model.clearGrid()
                }
            }
            .padding()
            .background(.blue)
            .cornerRadius(9)
            .foregroundColor(.white)
            
        }
    }
}

struct Clear_Grid_Picker_Previews: PreviewProvider {
    static var previews: some View {
        Clear_Grid_Picker(model: GridModel())
    }
}
