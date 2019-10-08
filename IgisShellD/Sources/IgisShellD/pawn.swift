import Igis

class Pawn : Piece {



    
    init(_ color:String) {
        super.init(color)
        self.type = "p"
    }

    
    override func moveList() -> [Point] {
        return []
    }

    override func legalMoves(boardstate:[[Piece?]]) -> [Point] {
        return []
    }

    
}
