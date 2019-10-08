import Igis

class King : Piece {



    
    init(_ color:String) {
        super.init(color)
        self.type = "k"
    }
    
    override func moveList() -> [Point] {
        return []
    }

    override func legalMoves(boardstate:[[Piece?]]) -> [Point] {
        return []
    }




}
