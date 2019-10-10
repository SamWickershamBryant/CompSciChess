import Igis

class Queen : Piece {



    
    init(_ color:String) {
        super.init(color)
        self.type = "q"

        self.imageLinkWhite = "https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Chess_qlt45.svg/50px-Chess_qlt45.svg.png"
        self.imageLinkBlack = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Chess_qdt45.svg/50px-Chess_qdt45.svg.png"
    }
    
    override func moveList(boardstate:[[Piece?]]) -> [Point] {

        return parseBishopMoves(boardstate:boardstate) + parseRookMoves(boardstate:boardstate)
    }

    override func legalMoves(boardstate:[[Piece?]]) -> [Point] {
        return moveList(boardstate:boardstate).filter({!Board.moveLeavesKingInDanger(from:self.position, to:$0, boardstate:boardstate)})
    }

    
}
