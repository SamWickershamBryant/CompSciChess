import Igis

class Painter : PainterBase {
    
    
    
    required init() {
    }

    override func framesPerSecond() -> Int {
        return 10
    }
    
    override func setup(canvas:Canvas) {
        let newBoard = Board(topLeft:Point(x:100,y:100), size:512, boardstate: Board.defaultBoardstate)
        //      print(newBoard.boardstate)
        newBoard.setPositions()
        newBoard.renderBoard(canvas:canvas)
       // newBoard.renderMoves(of:Point(x:4,y:3), canvas:canvas)
        newBoard.renderMoves(of:Point(x:3,y:3), canvas:canvas)
       // newBoard.renderMoves(of:Point(x:2,y:4), canvas:canvas)
        
        newBoard.renderPiecesAsText(canvas:canvas)
        newBoard.debug()

       
        print("nice")
       
       
       
//        print("Piece at (4,0) is \(newBoard.pieceAt(Point(x:4,y:0))!.type)")
  //      print("Piece at (2,3) is \(newBoard.pieceAt(Point(x:2,y:3)))")
    //    print("Piece at (4,6) is \(newBoard.pieceAt(Point(x:4,y:6))!.type)")


        

        
    }
    
    override func render(canvas:Canvas) {

    }

    override func calculate(canvasId:Int, canvasSize:Size?) {
        
    }

    override func onClick(location:Point) {

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
