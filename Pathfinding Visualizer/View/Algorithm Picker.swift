//
//  Algorithm Picker.swift
//  Pathfinding Visualizer
//
//  Created by Joshua Yang on 2022/8/30.
//

import SwiftUI

enum Algorithms {
    case diijkstra
    case aStar
}

struct Algorithm_Picker: View {
    @State private var selectedAlgorithm = Algorithms.diijkstra
    var model: GridModel
    
    var body: some View {
        HStack {
            Text("Algorithm: ")
            Picker("Algorithm:", selection: $selectedAlgorithm) {
                Text("Diijkstra")
                    .tag(Algorithms.diijkstra)
                Text("A Star")
                    .tag(Algorithms.aStar)
            }
            .pickerStyle(.menu)
            .onChange(of: selectedAlgorithm) { tag in
                switch tag {
                case .diijkstra:
                    model.setAlgorithm(algorithm: dijkstra)
                case .aStar:
                    model.setAlgorithm(algorithm: aStar)
                }
            
            }
            
            Button("Visualize!") {
                model.searched = false
                model.visualizeAlgorithm()
            }
            .padding()
            .background(.blue)
            .cornerRadius(9)
            .foregroundColor(.white)
            
        }
    }
}

struct Algorithm_Picker_Previews: PreviewProvider {
    static var previews: some View {
        Algorithm_Picker(model: GridModel())
    }
}
