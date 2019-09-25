import Igis

class Board {

    var topLeft : Point 
    var size : Int
    let outLineColor : Color
    let inLineColor : Color
    let squareColor : [Color]
    let lineWidth : Int    
    
    var boardstate : [[Piece?]]

    
    
        
    
   
   
   
   
   
    
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
    static func findPiece(_ piece:Piece, boardstate: [[Piece?]]) -> [Point]{
        
        var positions : [Point] = []
        for row in 0...7 {
            for element in 0...7 {
                if boardstate[row][element] != nil {
                    if boardstate[row][element]!.type == piece.type &&
                         boardstate[row][element]!.color == piece.color {
                        positions.append (boardstate[row][element]!.position)
                    }
                }
            }
        }
        return positions
    }

    func aliveWhitePieces() -> [Piece] { 
        var whitePieces = [Piece]()
        for row in 0...7 {
            for column in 0...7 {
                let piece = boardstate[row][column]
                if piece != nil {
                    if piece!.color == "w" {
                        whitePieces.append(piece!)
                    }
                }
            }
        }
        return whitePieces
    }
    func aliveBlackPieces() -> [Piece] { 
        var blackPieces = [Piece]()
        for row in 0...7 {
            for column in 0...7 {
                let piece = boardstate[row][column]
                if piece != nil {
                    if piece!.color == "b" {
                        blackPieces.append(piece!)
                    }
                }
            }
        }
        return blackPieces
    }
    
    // Boolean, if king in check return true
    /*func isBlackKingInDanger() -> Bool {
        let kingPos = findPiece(Piece.bKing)
        let whitePieces = aliveWhitePieces()
        for wPiece in whitePieces {
            if wPiece.legalMoves == kingPos {
               }
        }
        
        return false
    }
 
    func isWhiteKingInDanger() -> Bool {
        
        return false
    }*/
    
    static func inBounds(_ pos:Point) -> Bool {
        return pos.x <= 7 && pos.y <= 7 && pos.x >= 0 && pos.y >= 0
    }
        func movePiece(from:Point, to:Point) -> String? {
        return nil
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
