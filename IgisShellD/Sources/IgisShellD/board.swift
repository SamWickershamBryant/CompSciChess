import Igis

class Board {

    var topLeft : Point 
    var size : Int
    let outLineColor : Color
    let inLineColor : Color
    let squareColor : [Color]
    let lineWidth : Int        
    var boardstate : [[Piece?]]
    var enPassant : [Point]
          
    init(topLeft:Point, size:Int, boardstate:[[Piece?]] = Board.defaultBoardstate,
         outLineColor:Color = Color(.black), inLineColor:Color = Color(.black), squareColor:[Color] = [Color(.gray), Color(.royalblue)],
         lineWidth:Int = 2){
        self.topLeft = topLeft
        self.size = size // input not sanitized... yet (MUST be divisible by 8)
        self.boardstate = boardstate
        self.outLineColor = outLineColor
        self.inLineColor = inLineColor
        self.squareColor = squareColor
        self.lineWidth = lineWidth
    }

    
    
    static func pieceAt(_ position:Point, boardstate: [[Piece?]]) -> Piece? {        
        if boardstate[position.y][position.x] == nil {
            return nil
        } else {
            return boardstate[position.y][position.x]!
        }
    } 
    static func findPiece(_ color:String,_ type:String, boardstate: [[Piece?]]) -> [Point]{
        
        var positions : [Point] = []
        for row in 0...7 {
            for element in 0...7 {
                if boardstate[row][element] != nil {
                    if boardstate[row][element]!.type == type &&
                         boardstate[row][element]!.color == color {
                        positions.append (boardstate[row][element]!.position)
                    }
                }
            }
        }
        return positions
    }
    // This will display the board without having to use images
    func displayBoard() {
        print("   0   1   2   3   4   5   6   7  ")
        var count = 0
        for row in 0...7 {
            for column in 0...7 {
                if column == 0 {
                    print("\(count)", terminator: " ")
                }
                boardstate[row][column] != nil ? print(" \(boardstate[row][column]!.color)\(boardstate[row][column]!.type) ",terminator: " ") : print(" - ", terminator: " ")
            }            
            print("\n")
            count += 1
        }
    }    
    func alivePieces(side:String) -> [Piece] { 
        var whitePieces = [Piece]()
        for row in 0...7 {
            for column in 0...7 {
                let piece = boardstate[row][column]
                if piece != nil {
                    if piece!.color == side {
                        whitePieces.append(piece!)
                    }
                }
            }
        }
        return whitePieces
    }
    static func inBounds(_ pos:Point) -> Bool {
        return pos.x <= 7 && pos.y <= 7 && pos.x >= 0 && pos.y >= 0
    }
    func setPositions() {
        for x in 0...7 {
            for y in 0...7 {
                if boardstate[y][x] != nil {
                    let piece = boardstate[y][x]
                    piece!.position = Point(x:x,y:y)
                }
            }
        }
    }    
    func movePiece(from:Point, to:Point) {
        guard Board.pieceAt(from,boardstate:boardstate) != nil else {
            print("No piece at pos: \(from.x),\(from.y)")
        }
        guard Board.inBounds(to) != false else {
            print("Move to pos is out of bounds")
            return
        }
        let piece = Board.pieceAt(from,boardstate:boardstate)

        if Board.pieceAt(Point(x:to.x,y:to.y),boardstate:boardstate) != nil {
            // if a pieces point is -1,-1 its considered "dead"
            Board.pieceAt(Point(x:to.x,y:to.y),boardstate:boardstate)!.position = Point(x:-1,y:-1)
        }
        boardstate[to.y][to.x] = piece
        boardstate[from.y][from.x] = nil
    }
    
    // moveBoard moves the entire board to a position (topleft = destination)
    func moveBoard(topLeft:Point) {
        self.topLeft = topLeft
    }

    
    func resizeBoard(size:Int) {
        self.size = size
    }

    func renderBoard(canvas:Canvas) {
        //render squares, then inlines, then outlines in that order
        
         let sideLength = size / 8 // side length of a single square

         //render squares:

        func incrementColor(index: inout Int) {
            if index >= squareColor.count - 1 {
                index = 0
            } else {
                index += 1
            }
        }
        
        var colorIndex = 0
        
        for column in 0 ... 7 {
            for row in 0 ... 7 {
                var __row = row
                if (column % 2 != 0) {
                    __row = 7 - row
                }
                let squareTopLeft = Point(x:topLeft.x + (__row * sideLength),
                                          y:topLeft.y + (column * sideLength))
                
                let rect = Rect(topLeft:squareTopLeft, size:Size(width:sideLength, height:sideLength))
                let rectangle = Rectangle(rect:rect, fillMode: .fill)
                let fillStyle = FillStyle(color:squareColor[colorIndex])
                canvas.render(fillStyle)
                canvas.render(rectangle)
                incrementColor(index:&colorIndex)
                
            }
        }
        //render inLines:
        let inStrokeStyle = StrokeStyle(color:inLineColor)
        canvas.render(inStrokeStyle)
        canvas.render(LineWidth(width:lineWidth))
        for row in 1 ... 7 {
            let verticalLine = Lines(from:Point(x:topLeft.x + (row * sideLength),
                                                y:topLeft.y),
                                     to:Point(x:topLeft.x + (row * sideLength),
                                              y:topLeft.y + size))
            
            canvas.render(verticalLine)
        }

        for collumn in 1 ... 7 {
            let horizontalLine = Lines(from:Point(x:topLeft.x,
                                                  y:topLeft.y + (collumn * sideLength)),
                                       to:Point(x:topLeft.x + size,
                                                y:topLeft.y + (collumn * sideLength)))
            canvas.render(horizontalLine)
        }

        //render outLines:
        let outStrokeStyle = StrokeStyle(color:outLineColor)
        canvas.render(outStrokeStyle)
        canvas.render(LineWidth(width:lineWidth))

        let outRect = Rect(topLeft:topLeft, size:Size(width:size, height:size))
        let outRectangle = Rectangle(rect:outRect, fillMode: .stroke)
        canvas.render(outRectangle)
        
        
        
    }

    

    
    

}
