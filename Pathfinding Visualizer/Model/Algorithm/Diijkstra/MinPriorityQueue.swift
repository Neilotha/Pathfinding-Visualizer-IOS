//
//  MinPriorityQueue.swift
//  Pathfinding Visualizer
//
//  Created by Joshua Yang on 2022/8/16.
//

import Foundation

struct MinPriorityQueue {
    var heap: [Node] = []
    
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
        let tmp = heap[i]
        heap[i] = heap[j]
        heap[j] = tmp
    }
    
//    shift up the node inorder to maintain the heap priority
    mutating func shiftUp(_ i: Int) {
        var currentNode = i
        while i > 0 && heap[currentNode].distance < heap[getParent(currentNode)].distance {
//            swap parent and current node
            swap(currentNode, getParent(currentNode))
        
            
            currentNode = getParent(currentNode)
            
        }
        
    }
    
    mutating func shiftDown(_ i: Int) {
        var minIndex = i
        
//        compare with left child
        let l = getLeftChild(i)
        if l < heap.count && heap[l].distance < heap[minIndex].distance {
            minIndex = l
        }
        
//        compare with right child
        let r = getRightChild(i)
        if r < heap.count && heap[r].distance < heap[minIndex].distance {
            minIndex = r
        }
        
//        if minIndex been updated
        if i != minIndex {
            swap(i, minIndex)
            shiftDown(minIndex)
        }
    }
    
    mutating func inert(_ p: Node) {
        heap.append(p)
        heap[heap.count - 1].inQueue = true
        shiftUp(heap.count - 1)
    }
    
    mutating func extractMin() -> Node {
        let result = heap.removeFirst()
        
        if heap.count > 0 {
            shiftDown(0)
        }
        
        return result
    }
    
    mutating func changePriority(_ i: Int, _ p: Int) {
        let oldP = heap[i].distance
        heap[i].distance = p
        
        if p < oldP {
            shiftUp(i)
        }
        else {
            shiftDown(i)
        }
    }
    
    func getMin() -> Node {
        heap[0]
    }
    
    mutating func remove(i: Int) {
        heap[i].distance = getMin().distance - 1
        
        shiftUp(i)
        extractMin()
    }
    
    func getIndex(of node: Node) -> Int {
        heap.firstIndex(of: node)!
    }
}


