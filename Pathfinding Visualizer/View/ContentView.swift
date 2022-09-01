//
//  ContentView.swift
//  Pathfinding Visualizer
//
//  Created by Joshua Yang on 2022/8/11.
//

import SwiftUI

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

struct ContentView: View {
    @StateObject var model = GridModel()
    
    var body: some View {
        VStack {
            Spacer()
            Control_panel_View(model: model)
        
            GeometryReader { geo in
                GridView(model: self.model, height: Int(geo.size.height), width: Int(geo.size.width))
                    .onRotate { _ in
                        model.updateModel(height: Int(geo.size.height), width: Int(geo.size.width))
                            }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}
