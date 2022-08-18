//
//  ContentView.swift
//  Pathfinding Visualizer
//
//  Created by Joshua Yang on 2022/8/11.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = GridModel(height: 30, width: 30)
    
    var body: some View {
        VStack {
            Control_panel_View(model: model)
        
            GeometryReader { geo in
                GridView(model: self.model, height: Int(geo.size.height), width: Int(geo.size.width))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
