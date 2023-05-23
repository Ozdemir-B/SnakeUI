//
//  PartSnake.swift
//  SnakeUI
//
//  Created by Berkay Ozdemir on 23.05.2023.
//

import Foundation

import SwiftUI


struct PartSnake{
    var index:Int
    var position:CGSize
    var direction:String
    
    var renderPart:some View{
        return Circle().frame(width:22,height:22)
    }
}

struct AllSnake{
    
    var parts:[PartSnake] = [PartSnake(index: 0, position: CGSize.zero, direction: "right")]
    
    
    var renderSnake:some View{
        ForEach(parts, id:\.index){
                part in
                if part.index == 0{
                    part.renderPart.offset(part.position).foregroundColor(.brown)
                } else {
                    part.renderPart.offset(part.position).foregroundColor(.brown)
                }
                
                
            }
    }
    
    
    mutating func addToTail() {
        if let last = self.parts.last{
                
            var new = last
            //print("--before.posititon : \(new.position)")
            //completion()
            new.index += 1
            /*if new.direction == "right"{
                new.position.width += 20
            } else if new.direction == "left"{
                new.position.width -= 20
            } else if new.direction == "up"{
                new.position.height += 20
            } else {
                new.position.height -= 20
            }*/
            self.parts.append(new)
            
        } else {
            print("no last tail")
            //completion()
        }
        
    }
    
    mutating func move(newDirection:String){
        self.swipePositionsAndDirections()
        self.moveHead(newDirection: newDirection)//,newPosition: newPosition)
    }
    
    mutating func moveHead(newDirection:String){
        
        if let p = parts.first{
            var old = p
            if p.direction == "up" && newDirection != "down"{
                self.parts[0].direction = newDirection
                self.parts[0].position.height -= 10
            } else if p.direction == "down" && newDirection != "up"{
                self.parts[0].direction = newDirection
                self.parts[0].position.height += 10
            } else if p.direction == "right" && newDirection != "left"{
                self.parts[0].direction = newDirection
                self.parts[0].position.width += 10
            } else if p.direction == "left" && newDirection != "right"{
                self.parts[0].direction = newDirection
                self.parts[0].position.width -= 10
            }
            
            
            
            //return old
        } else {
            //return nil
        }
        
    }
    
    mutating func swipePositionsAndDirections() {
        //rint("count : \(self.parts.count)")
        let old_parts = self.parts
        for i in 1..<parts.count{
            //print("\(parts[i-1].position) -- \(parts[i].position)")
            self.parts[i].position = old_parts[i-1].position
            self.parts[i].direction = old_parts[i-1].direction
            //self.parts[i].position = self.parts[i-1].position
            //self.parts[i].direction = self.parts[i-1].direction
        }
        //print("---- count : \(self.parts.count)")
        //print(" --- last index : \(self.parts.last?.index ?? -1)")
    }
    
    func didEatApple(applePosition:CGSize) -> Bool{
        
        if let head = self.parts.first{
            let height_diff = abs(head.position.height - applePosition.height)
            let width_diff = abs(head.position.width - applePosition.width)
            if height_diff < 30 && width_diff < 30 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
        
        
    }
    
    func didEatItself() -> Bool { //
        if parts.count > 3{
            for i in 1..<parts.count{
                let th = parts[i].position.height
                let tw = parts[i].position.width
                
                let hh = parts[0].position.height
                let hw = parts[0].position.width
                
                if abs(th-hh) < 10 && abs(tw-hw) < 10 {
                    return true
                }
            }
            return false
        } else {
            return false
        }
        
    }

    func setApplePosition() -> CGSize{
        
        return CGSize.zero
    }
    
    
    
}
