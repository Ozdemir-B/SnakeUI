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
    
    @State var openPause:Bool = false
    
    @State var started:Bool = false
    
    func randomApplePosition() -> CGSize {
        
        let random_width:CGFloat = Array(stride(from: -UIScreen.main.bounds.size.width*0.4, to: UIScreen.main.bounds.size.width*0.4 , by: 1)).shuffled().first!
        
        let random_height:CGFloat = Array(stride(from: -UIScreen.main.bounds.size.height*0.3, to: UIScreen.main.bounds.size.height*0.4, by: 1)).shuffled().first!
        let return_val = CGSize(width: random_width, height: random_height)
        print("apple_position : \(return_val)")
        print("device : \(UIScreen.main.bounds.size)")
        return return_val
        
        
    }
    
    var body: some View {
        ZStack {
            Image("grass_bg").resizable(resizingMode:.tile).edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    Text("Score : \(snake.parts.count-1)").foregroundColor(.black).font(.system(size:25,weight:.medium,design:.rounded))
                    Spacer()
                    Spacer()
                    Button(action: {
                        started.toggle()
                    }, label: {
                        if started{
                            Image(systemName: "pause").foregroundColor(.black).font(.system(size:25))
                        } else {
                            Image(systemName: "play.fill").foregroundColor(.black).font(.system(size:25))
                        }
                    })
                    Spacer()
                    Button(action: {openPause.toggle()}, label: {Image(systemName: "line.3.horizontal").foregroundColor(.black).font(.system(size:30,weight:.medium))})
                        
                }.padding(.top,60).padding().background(.ultraThinMaterial,in:RoundedRectangle(cornerRadius: 0)).edgesIgnoringSafeArea(.all)
                Spacer()
            }
            .sheet(isPresented: $openPause, content: {
                List{
                    
                }
            })
            
            ZStack{
                ZStack{
                    
                    
                    snake.renderSnake
                    
                    Image(systemName: "apple.logo").resizable().scaledToFit().foregroundColor(.red).frame(width:50,height:50).offset(self.applePosition)
                    
                    //RoundedRectangle(cornerRadius: 0).frame(width:50,height:50).offset(self.applePosition).foregroundColor(.blue)
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
            if started{
                snake.move(newDirection: self.direction)
                
                if snake.didEatApple(applePosition: self.applePosition){
                    self.applePosition = self.randomApplePosition()
                    snake.addToTail()
                }
                if snake.didEatItself(){
                    started = false
                    snake.parts = [snake.parts.first!]
                    snake.parts[0].position = CGSize.zero
                }
            }
            
            
            
            
        })
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
