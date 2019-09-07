import Igis

class Painter : PainterBase {
    
    
    
    required init() {
    }

    override func framesPerSecond() -> Int {
        return 10
    }
    
    override func setup(canvas:Canvas) {
        let newBoard = Board(topLeft:Point(x:0,y:0), size:64)
        print(newBoard.boardstate)
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
