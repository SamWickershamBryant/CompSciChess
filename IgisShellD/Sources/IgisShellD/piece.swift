
import Igis

class Piece {

    let type : String
    let color : String // "b" or "w"

    //global piece variable, this makes it so every in every board, duplicate pieces have the same address and therefore if compared Piece.wPawn == Piece.wPawn : true.
    //To check what type a piece is it is simply Piece.wPawn.type or .id()
    static let wPawn = Piece(type:"p", color:"w")
    static let wRook = Piece(type:"r", color:"w")
    static let wKnight = Piece(type:"n", color:"w")
    static let wBishop = Piece(type:"b", color:"w")
    static let wQueen = Piece(type:"q", color:"w")
    static let wKing = Piece(type:"k", color:"w")

    static let bPawn = Piece(type:"p", color:"b")
    static let bRook = Piece(type:"r", color:"b")
    static let bKnight = Piece(type:"n", color:"b")
    static let bBishop = Piece(type:"b", color:"b")
    static let bQueen = Piece(type:"q", color:"b")
    static let bKing = Piece(type:"k", color:"b")

    
    init(type:String, color:String) {
        self.type = type
        self.color = color
    }

    func id() -> String {
        return "Color: \(self.color), Type: \(self.type)" 
    }

<<<<<<< HEAD
    func legalMoves(pos:Point,boardstate:[[Piece?]]) -> [Point] {
=======
    // returns ALL legal moves for the piece in given position, if position is empty return an empty array
    func legalMoves(_ position:Point, boardstate:[[Piece?]]) -> [Point] {
        
    }

   
    func legalMoves(pos:Point, boardState: [[Piece?]]) -> [Point] {
>>>>>>> 39415d9686e829703b13c9e35b23ac905ae7659d
        
        // Is the point in bounds
        guard Board.inBounds(pos) == false else {
            print("The point is not in bounds")
            return []
        }        
        // Is there is a piece        
        guard Board.pieceAt(pos, boardstate:boardstate) != nil else {
            print("No piece at position : \(pos)")
            return []
        }
        
        var legalMoves = [Point]()
        
        let piece = Board.pieceAt(pos,boardstate:boardstate)
        let piecePos = Board.findPiece(piece!, boardstate:boardstate)[0]
        
        // legal moves for knight
        if piece!.type == "n" {            
            var legalMovesUnfiltered = [Point(x:piecePos.x+2,y:piecePos.y+1),Point(x:piecePos.x+1,y:piecePos.y+2),
                                        Point(x:piecePos.x-2,y:piecePos.y-1),Point(x:piecePos.x-1,y:piecePos.y-2),
                                        Point(x:piecePos.x+1,y:piecePos.y-2),Point(x:piecePos.x]
            

        }        
        return []
    }







    

}
