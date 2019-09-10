import Igis


class Board {
    
    /*
     Board:
     Board class will only display and update the board, move pieces, check if king is in check, etc etc...
     Game class will contruct instances of Board and position the board in an appropriate position,
     Game class will handel parsing clicks on the board and the board will not handle that, the Game class will instead
     parse where the user is clicking and call the board class for board related functions.
     */
    
    var topLeft : Point // Top left of the entire board
    var size : Int // Only accept integer divisible by 8
    // size is the length of a side of the -entire- board.
    //must be divisbile by eight so there is the correct amount of pixels for 64 inner squares.
    
    
    
    
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
    
    init(topLeft:Point, size:Int, boardstate:[[Piece?]] = Board.defaultBoardstate){
        self.topLeft = topLeft
        self.size = size // input not sanitized... yet (MUST be divisible by 8)
        self.boardstate = boardstate
    }
 
    func pieceAt(_ position:Point) -> Piece? {
        if boardstate[position.y][position.x] == nil {
            return nil
        } else {
            return boardstate[position.y][position.x]
        }
    }
    func findPiece(piece:Piece) -> Point? {
        for row in 0...8 {
            for element in 0...8 {
                if boardstate[row][element]! === piece {
                    return Point(x:row,y:element)
                }
            }
        }
        return nil
    }
    // Boolean, if king in check return true
    func KingInDanger(piece:Piece) -> Bool {                      
    }

    // returns ALL legal moves for the piece in given position, if position is empty return an empty array
    func legalMoves(for:Point) -> [Point] {
        return []
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

    // resizeBoard lowers board size by 8 in chosen direction, direction=1 : Size UP
    func resizeBoard(direction:Bool) {//                       direction=0 : Size DOWN
//
    }

}
