
import Igis

class Piece {

    var type: String


    let color : String

    static let wPawn = Piece(type:"p", color:"w")
    static let wRook = Piece(type:"r", color:"w")
    static let wKnight = Piece(type:"n", color:"w")
    static let wBishop = Piece(type:"b", color:"w")
    static let wQueen = Piece(type:"q", color:"w")
    static let wKing = Piece(type:"k", color:"w")

    static let bPawn = Piece(type:"p", color:"w")
    static let bRook = Piece(type:"r", color:"w")
    static let bKnight = Piece(type:"n", color:"w")
    static let bBishop = Piece(type:"b", color:"w")
    static let bQueen = Piece(type:"q", color:"w")
    static let bKing = Piece(type:"k", color:"w")

    
    init(type:String, color:String) {
        self.type = type
        self.color = color        
    }






    

}
