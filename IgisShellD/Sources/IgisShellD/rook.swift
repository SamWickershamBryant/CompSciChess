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
        return moveList(boardstate:boardstate).filter({!Board.moveLeavesKingInDanger(from:self.position, to:$0, boardstate:boardstate)})
    }


    

    
}
