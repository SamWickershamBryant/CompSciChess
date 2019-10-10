import Igis

class Bishop : Piece {



    
    init(_ color:String) {
        super.init(color)
        self.type = "b"
    }

    
 
    override func moveList(boardstate:[[Piece?]]) -> [Point] {
        return parseBishopMoves(boardstate:boardstate)
    }

    override func legalMoves(boardstate:[[Piece?]]) -> [Point] {
        return moveList(boardstate:boardstate).filter({!Board.moveLeavesKingInDanger(from:self.position, to:$0, boardstate:boardstate)})
    }






}
