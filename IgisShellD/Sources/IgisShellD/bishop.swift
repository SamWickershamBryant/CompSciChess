import Igis

class Bishop : Piece {



    
    init(_ color:String) {
        super.init(color)
        self.type = "b"

        self.imageLinkWhite = "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b1/Chess_blt45.svg/50px-Chess_blt45.svg.png"
        self.imageLinkBlack = "https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/Chess_bdt45.svg/50px-Chess_bdt45.svg.png"
    }

    
 
    override func moveList(boardstate:[[Piece?]]) -> [Point] {
        return parseBishopMoves(boardstate:boardstate)
    }

    override func legalMoves(boardstate:[[Piece?]]) -> [Point] {
        return moveList(boardstate:boardstate).filter({!Board.moveLeavesKingInDanger(from:self.position, to:$0, boardstate:boardstate)})
    }






}
