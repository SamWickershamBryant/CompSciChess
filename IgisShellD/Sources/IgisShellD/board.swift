import Igis

class Board {
    
     /*
     Board:
     Board class will only display and update the board, move pieces, check if king is in check, etc etc...
     Game class will contruct instances of Board and position the board in an appropriate position,
     Game class will handle parsing clicks on the board, the Game class will instead
     parse where the user is clicking and call the board class for board related functions.
     */
    
    var topLeft : Point // Top left of the entire board
    var size : Int // Only accept integer divisible by 8
    // size is the length of a side of the -entire- board.
    //must be divisbile by eight so there is the correct amount of pixels for 64 inner squares.
    let outLineColor : Color
    let inLineColor : Color
    let squareColor : [Color]
    let lineWidth : Int    
    
    var boardstate : [[Piece?]] // nil = empty space
    // example boardstate:
   /* [ . . . . . . . . ]   <- [Piece.bRook, Piece.wQueen, null, etc] -- each dot is an *optional* Piece, ex: Piece.wKnight
      [ . . . . . . . . ]
      [ . . . . . . . . ]
      [ . . . . . . . . ]
   8  [ . . . . . . . . ]
      [ . . . . . . . . ]
      [ . . . . . . . . ]
      [ . . . . . . . . ]      
               8      
    */
    // Default starting boardstate for standard game:
    static let defaultBoardstate = [[Piece.bRook, Piece.bKnight, Piece.bBishop, Piece.bQueen, Piece.bKing, Piece.bBishop, Piece.bKnight, Piece.bRook],
     /* Board.defaultBoardstate*/   [Piece.bPawn, Piece.bPawn, Piece.bPawn, Piece.bPawn, Piece.bPawn, Piece.bPawn, Piece.bPawn, Piece.bPawn],
                                    [nil, nil, nil, nil, nil, nil, nil, nil],
                                    [nil, nil, nil, nil, nil, nil, nil, nil],
                                    [nil, nil, nil, nil, nil, nil, nil, nil],
                                    [nil, nil, nil, nil, nil, nil, nil, nil],
                                    [Piece.wPawn, Piece.wPawn, Piece.wPawn, Piece.wPawn, Piece.wPawn, Piece.wPawn, Piece.wPawn, Piece.wPawn],
                                    [Piece.wRook, Piece.wKnight, Piece.wBishop, Piece.wQueen, Piece.wKing, Piece.wBishop, Piece.wKnight, Piece.wRook]]
    
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

    // changed to return array of Points, if you search for a pawn, it should return all pawns on the board. If none found, simply return empty array

    static func findPiece(_ piece:Piece, boardstate: [[Piece?]]) -> [Point]{

        var positions : [Point] = []
        for row in 0...7 {
            for element in 0...7 {
                if boardstate[row][element] === piece {
                    positions.append(Point(x:element,y:row))
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
    
    // Moves piece from position to new position... check if move is legal,
    //check if it is a castling move and ensure appropriate pieces get moved and that it is legal
    //Optional string return is placeholder for however we decide to manage tracking what pieces got destroyed, if its now in check or mate, etc..
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
