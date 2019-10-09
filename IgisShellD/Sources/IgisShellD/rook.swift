import Igis

class Rook : Piece {




    
    init(_ color:String) {
        super.init(color)
        self.type = "r"
    }

    
    override func moveList(boardstate:[[Piece?]]) -> [Point] {
        return parseRookMoves(boardstate:boardstate)
    }

    override func legalMoves(boardstate:[[Piece?]]) -> [Point] {
        return []
    }


    

    
}
