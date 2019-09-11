
import Igis

class Piece {

    var type : String
    let color : String

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






    

}
