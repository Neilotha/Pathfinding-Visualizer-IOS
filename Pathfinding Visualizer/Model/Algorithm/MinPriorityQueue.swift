//
//  MinPriorityQueue.swift
//  Pathfinding Visualizer
//
//  Created by Joshua Yang on 2022/8/16.
//

import Foundation

struct MinPriorityQueue {
    var heap: [Node] = []
    let isHigherPriority: (PriorityInfoProtocol, PriorityInfoProtocol) -> Bool
    
    init(priorityFunction: @escaping (PriorityInfoProtocol, PriorityInfoProtocol) -> Bool) {
        self.isHigherPriority = priorityFunction
    }
    
    func getParent(_ i: Int) -> Int {
        (i - 1) / 2
    }
    
    func getLeftChild(_ i: Int) -> Int {
        (i * 2) + 1
    }
    
    func getRightChild(_ i: Int) -> Int {
        (i * 2) + 2
    }
    
    mutating func swap(_ i: Int,_ j: Int) {
        guard i != j else { return }
        heap.swapAt(i, j)
    }
    
//    shift up the node inorder to maintain the heap priority
    mutating func shiftUp(_ i: Int) {
        var index = i
        while index > 0 && self.isHigherPriority(heap[index].priorityInfo!, heap[getParent(index)].priorityInfo!)  {
//            swap parent and current node
            swap(index, getParent(index))
        
            
            index = getParent(index)
            
        }
        
    }
    
    mutating func shiftDown(_ i: Int) {
        var minIndex = i
        
//        compare with left child
        let l = getLeftChild(i)
        if l < heap.count && self.isHigherPriority(heap[l].priorityInfo!, heap[minIndex].priorityInfo!) {
            minIndex = l
        }
        
//        compare with right child
        let r = getRightChild(i)
        if r < heap.count && self.isHigherPriority(heap[r].priorityInfo!, heap[minIndex].priorityInfo!) {
            minIndex = r
        }
        
//        if minIndex been updated
        if i != minIndex {
            swap(i, minIndex)
            shiftDown(minIndex)
        }
    }
    
    mutating func insert(_ p: Node) {
        p.inQueue = true
        heap.append(p)
        shiftUp(heap.count - 1)
    }
    
    mutating func extractMin() -> Node {
        heap.swapAt(0, heap.count - 1)
        let result = heap.removeLast()
        result.inQueue = false
        
        if heap.count > 0 {
            shiftDown(0)
        }
        
        return result
    }
    
    mutating func changePriority(_ i: Int, _ p: PriorityInfoProtocol) {
        let oldP = heap[i].priorityInfo!
        heap[i].priorityInfo = p
        
        
        if isHigherPriority(p, oldP) {
            shiftUp(i)
        }
        else {
            shiftDown(i)
        }
    }
    
    func getMin() -> Node {
        heap[0]
    }
    
    
    func getIndex(of node: Node) -> Int {
        heap.firstIndex(of: node)!
    }
    
    mutating func buildHeap() {
        for index in (0 ..< heap.count / 2).reversed() {
            shiftDown(index)
        }
    }
}


