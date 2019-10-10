import Igis

class Queen : Piece {



    
    init(_ color:String) {
        super.init(color)
        self.type = "q"
    }
    
    override func moveList(boardstate:[[Piece?]]) -> [Point] {

        return parseBishopMoves(boardstate:boardstate) + parseRookMoves(boardstate:boardstate)
    }

    override func legalMoves(boardstate:[[Piece?]]) -> [Point] {
        return moveList(boardstate:boardstate).filter({!Board.moveLeavesKingInDanger(from:self.position, to:$0, boardstate:boardstate)})
    }

    
}
