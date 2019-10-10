import Igis

class Rook : Piece {




    
    init(_ color:String) {
        super.init(color)
        self.type = "r"

        self.imageLinkWhite = "https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Chess_rlt45.svg/50px-Chess_rlt45.svg.png"
        self.imageLinkBlack = "https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/Chess_rdt45.svg/50px-Chess_rdt45.svg.png"
    }

    
    override func moveList(boardstate:[[Piece?]]) -> [Point] {
        return parseRookMoves(boardstate:boardstate)
    }

    override func legalMoves(boardstate:[[Piece?]]) -> [Point] {
        return moveList(boardstate:boardstate).filter({!Board.moveLeavesKingInDanger(from:self.position, to:$0, boardstate:boardstate)})
    }


    

    
}
