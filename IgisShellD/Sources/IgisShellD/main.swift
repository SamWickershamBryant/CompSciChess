import Igis

class Painter : PainterBase {
    let library : ImageLibrary
    let game : Game
    
    required init() {
        library = ImageLibrary()

            
        
        
        game = Game()
        print("Init ran")
    }

    override func framesPerSecond() -> Int {
        return 10
    }
    
    override func setup(canvas:Canvas) {
        library.loadImages(canvas:canvas)
        game.setup(canvas:canvas)
        print("game setup")
        
       
       
       
        
       
       

       
       
       
       
       
//        print("Piece at (4,0) is \(newBoard.pieceAt(Point(x:4,y:0))!.type)")
  //      print("Piece at (2,3) is \(newBoard.pieceAt(Point(x:2,y:3)))")
    //    print("Piece at (4,6) is \(newBoard.pieceAt(Point(x:4,y:6))!.type)")


        

        
    }
    
    override func render(canvas:Canvas) {
        if game.needsToRender() && game.isReady(imageLibrary:library) {
            game.renderGame(imageLibrary:library, canvas:canvas)
        }
    }

    override func calculate(canvasId:Int, canvasSize:Size?) {
        
    }

    override func onClick(location:Point) {
        game.onClick(point:location)
    }

    override func onMouseMove(location:Point) {

    }

    override func onKeyDown(key:String, code:String, ctrlKey:Bool,
                            shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        
    }
    
}

print("Starting...")
do {
    let igis = Igis()
    try igis.run(painterType:Painter.self)
} catch (let error) {
    print("Error: \(error)")
}

// its lit boys
// it is doe
