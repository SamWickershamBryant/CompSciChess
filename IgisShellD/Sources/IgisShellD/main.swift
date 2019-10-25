import Igis

class Painter : PainterBase {
    let library : ImageLibrary
    static let game : Game = Game(users:[0,1])

    static var nextUser = 0

    var user : Int

    var menu : Menu

    var renderHolder : Int
    
    required init() {
        library = ImageLibrary()
        Painter.game.setup()
        user = Painter.nextUser
        Painter.nextUser += 1

        renderHolder = 0
        
        print("user no \(user)")
            
        menu = Menu(userId:user)
        menu.joinGame(game:Painter.game)
        //game = Game()
        print("Init ran")
    }

    override func framesPerSecond() -> Int {
        return 10
    }
    
    override func setup(canvas:Canvas) {
        library.loadImages(canvas:canvas)
        
        let clearScreen = Rectangle(rect:Rect(topLeft:Point(x:0, y:0), size:Size(width:5000, height:5000)), fillMode:.fillAndStroke)
        let fillStyle = FillStyle(color:Color(.white))
        canvas.render(fillStyle, clearScreen)
        
        //print("game setup")
       
//        print("Piece at (4,0) is \(newBoard.pieceAt(Point(x:4,y:0))!.type)")
  //      print("Piece at (2,3) is \(newBoard.pieceAt(Point(x:2,y:3)))")
    //    print("Piece at (4,6) is \(newBoard.pieceAt(Point(x:4,y:6))!.type)")


        

        
    }
    
    override func render(canvas:Canvas) {
        menu.update(imageLibrary:library, canvas:canvas)
        menu.canvasSize = canvas.canvasSize!
        menu.setAllRects(canvas:canvas)

        if renderHolder < 1 {
            print("canvasSize = \(menu.canvasSize)")
            renderHolder += 1
        }
    }

    override func calculate(canvasId:Int, canvasSize:Size?) {
        
    }

    override func onClick(location:Point) {
        menu.onClick(point:location)
        if Painter.game.board.inCheckmate(color:"b") {
            print("White wins!")
        }
        if Painter.game.board.inCheckmate(color:"w") {
            print("Black wins!")
        }
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
