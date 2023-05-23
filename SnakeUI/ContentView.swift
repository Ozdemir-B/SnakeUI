//
//  ContentView.swift
//  SnakeUI
//
//  Created by Berkay Ozdemir on 23.05.2023.
//

import SwiftUI

struct ContentView: View {
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    let timerAddSnake = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var direction:String = "right"
    
    @State var dragPosition:CGSize = CGSize.zero
    
    @State var dragStartLocation:CGPoint = CGPoint.zero
    @State var dragEndLocation:CGPoint = CGPoint.zero
    
    @State var snake = AllSnake()
    
    @State var applePosition = CGSize.zero
    
    func randomApplePosition() -> CGSize {
        
        let random_width:CGFloat = Array(stride(from: 100 as? CGFloat ?? CGFloat.zero, to: UIScreen.main.bounds.size.width/2 , by: 1)).shuffled().first!
        
        let random_height:CGFloat = Array(stride(from: 100 as? CGFloat ?? CGFloat.zero, to: UIScreen.main.bounds.size.height/2, by: 1)).shuffled().first!
        let return_val = CGSize(width: random_width, height: random_height)
        print("apple_position : \(return_val)")
        print("device : \(UIScreen.main.bounds.size)")
        return return_val
        
        
    }
    
    var body: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            ZStack{
                ZStack{
                    
                    
                    snake.renderSnake
                    
                    RoundedRectangle(cornerRadius: 0).frame(width:50,height:50).offset(self.applePosition).foregroundColor(.blue)
                }
                
                
            }
            
        }
        .onAppear{
            self.applePosition = self.randomApplePosition()
        }
        .onTapGesture(perform: {
            //snake.addToTail()
        })
        .gesture(
            DragGesture().onChanged{
                value in
                //dragPosition = value.translation
                
                dragStartLocation = value.startLocation
                dragEndLocation = value.location
                
            }.onEnded{
                value in
                /*withAnimation(){
                    dragPosition = CGSize.zero
                    
                }*/
                let y_dif = dragEndLocation.x - dragStartLocation.x
                let x_dif = dragEndLocation.y - dragStartLocation.y
                if abs(x_dif) > abs(y_dif){
                    if x_dif > 0{
                        self.direction = "down"
                    } else {
                        self.direction = "up"
                    }
                } else {
                    if y_dif > 0 {
                        self.direction = "right"
                    } else {
                        self.direction = "left"
                    }
                }
            })
        .onReceive(timer, perform: {
            time in
            //print(self.direction)
            
            snake.move(newDirection: self.direction)
            
            if snake.didEatApple(applePosition: self.applePosition){
                self.applePosition = self.randomApplePosition()
                snake.addToTail()
            }
            
            
            
        })
        .onReceive(timerAddSnake, perform: {
            time in
            
            //print("tail added")
            //print(snake.parts.count)
        })
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
