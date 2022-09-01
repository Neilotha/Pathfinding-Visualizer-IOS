//
//  Stats.swift
//  Pathfinding Visualizer
//
//  Created by Joshua Yang on 2022/9/1.
//

import SwiftUI

struct Stats: View {
    @ObservedObject var model: GridModel
    
    var body: some View {
        VStack {
            Text("Distance: ")
                .font(.system(size: 18))
            Text( model.shortestPathDistance == -1 ?
                  "No path" : "\(model.shortestPathDistance)")
        }
    }
}

struct Stats_Previews: PreviewProvider {
    static var previews: some View {
        Stats(model: GridModel())
    }
}
