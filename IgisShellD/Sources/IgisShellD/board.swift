import Igis



class Board {

    var topLeft : Point
    var size : Int // Only accept integer divisible by 8

    var boardstate : [[Piece?]] // nil = empty space
    // example boardstate:

    static let defaultBoardstate = [[Piece.bRook, Piece.bKnight, Piece.bBishop, Piece.bQueen, Piece.bKing, Piece.bBishop, Piece.bKnight, Piece.bRook],
                                    [Piece.bPawn, Piece.bPawn, Piece.bPawn, Piece.bPawn, Piece.bPawn, Piece.bPawn, Piece.bPawn, Piece.bPawn],
                                    [nil, nil, nil, nil, nil, nil, nil, nil],
                                    [nil, nil, nil, nil, nil, nil, nil, nil],
                                    [nil, nil, nil, nil, nil, nil, nil, nil],
                                    [nil, nil, nil, nil, nil, nil, nil, nil],
                                    [Piece.wPawn, Piece.wPawn, Piece.wPawn, Piece.wPawn, Piece.wPawn, Piece.wPawn, Piece.wPawn, Piece.wPawn],
                                    [Piece.wRook, Piece.wKnight, Piece.wBishop, Piece.wQueen, Piece.wKing, Piece.wBishop, Piece.wKnight, Piece.wRook]]
    
    init(){
    }

    func pieceAt(_ position:Point) { // 0 - 7, 0 - 7, a = 0, 1 = 0 etc etc..
        
        // traverse through boardstate and return piece at given positon.
    }

}
