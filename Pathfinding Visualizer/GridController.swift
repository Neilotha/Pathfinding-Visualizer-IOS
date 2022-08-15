//
//  GridController.swift
//  Pathfinding Visualizer
//
//  Created by Joshua Yang on 2022/8/11.
//

import Foundation
import UIKit

class GridController: UIView {
    class NodeView: UIView {
    }
    
    var grid: [[Node]]
    var updatedNodes: [NodeInfo] = []
    let maxColumn: Int
    let maxRow: Int
    let nodeSize: CGFloat
    var dragCallBack: (Int, Int) -> Void
    var endDragCallBack: () -> Void
    var nodeViews: Array<Array<NodeView>>!
    
    init(grid: [[Node]], maxColumn: Int, maxRow: Int, nodeSize: CGFloat, dragCallBack: @escaping (Int, Int) -> Void, endDragCallBack: @escaping () -> Void) {
        self.grid = grid
        self.maxColumn = maxColumn
        self.maxRow = maxRow
        self.nodeSize = nodeSize
        self.dragCallBack = dragCallBack
        self.endDragCallBack = endDragCallBack
        super.init(frame: CGRect(x: 0,
                                 y: 0,
                                 width: CGFloat(maxColumn) * nodeSize,
                                 height: CGFloat(maxRow) * nodeSize))
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupView() {
//        setup gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDrag(sender:)))
        tapGestureRecognizer.delegate = self

        let dragGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleDrag(sender: )))
        dragGestureRecognizer.minimumPressDuration = 0
        addGestureRecognizer(dragGestureRecognizer)
        
//        constructing view
        nodeViews = []
        for y in 0 ..< maxRow {
            nodeViews.append([])
            for x in 0 ..< maxColumn {
                let nodeView = createNodeView(nodeColor: nodeColor(state: grid[y][x].getState()))
                nodeView.frame = CGRect(
                    x: CGFloat(x) * nodeSize,
                    y: CGFloat(y) * nodeSize,
                    width: nodeSize,
                    height: nodeSize
                )
                nodeViews[y].append(nodeView)
                addSubview(nodeView)
            }
        }
        isUserInteractionEnabled = true
        
    }

    private func createNodeView(nodeColor: UIColor) -> NodeView {
        let nodeView = NodeView()
        nodeView.backgroundColor = nodeColor
        nodeView.layer.borderWidth = 0.5
        nodeView.layer.borderColor = UIColor.lightGray.cgColor
        nodeView.isUserInteractionEnabled = false
        return nodeView
    }
    
    private func nodeColor(state: NodeState) -> UIColor {
        var color: UIColor
        switch state {
        case .start:
            color = .green
        case .destination:
            color = .red
        case .visited:
            color = .blue
        case .wall:
            color = .black
        default:
            color = .white
        }
        
        return color
    }
    
    @objc private func handleDrag(sender: UIGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            drag(at: sender.location(in: self))
        case .ended:
            drag(at: sender.location(in: self))
            endDragCallBack()
        default:
            break
        }
    }
    
    private func drag(at point: CGPoint) {
        let x = Int(point.x / nodeSize)
        let y = Int(point.y / nodeSize)
        
        guard y < maxRow && x < maxColumn && y >= 0 && x >= 0 else { return }
        dragCallBack(y, x)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        for nodeInfo in updatedNodes {
            print("node view: [\(nodeInfo.row), \(nodeInfo.column)] update")
            nodeViews[nodeInfo.row][nodeInfo.column].backgroundColor = nodeColor(state: grid[nodeInfo.row][nodeInfo.column].getState())
        }
    }
    
    

}

extension GridController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
