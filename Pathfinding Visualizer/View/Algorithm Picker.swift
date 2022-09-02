//
//  Algorithm Picker.swift
//  Pathfinding Visualizer
//
//  Created by Joshua Yang on 2022/8/30.
//

import SwiftUI

fileprivate enum Algorithms {
    case diijkstra
    case aStar
}

struct Algorithm_Picker: View {
    @State private var selectedAlgorithm = Algorithms.diijkstra
    var model: GridModel
    
    var body: some View {
        HStack {
            Picker("Algorithm:", selection: $selectedAlgorithm) {
                Text("Diijkstra")
                    .tag(Algorithms.diijkstra)
                Text("A Star")
                    .tag(Algorithms.aStar)
            }
            .pickerStyle(MenuPickerStyle())
            .onChange(of: selectedAlgorithm) { tag in
                switch tag {
                case .diijkstra:
                    model.setAlgorithm(algorithm: dijkstra)
                    model.setAnimationSpeed(speed: 0.008)
                case .aStar:
                    model.setAlgorithm(algorithm: aStar)
                    model.setAnimationSpeed(speed: 0.02)
                }
            
            }
            
            Button("Visualize!") {
                model.searched = false
                model.visualizeAlgorithm()
            }
            .font(.system(size: 15))
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
