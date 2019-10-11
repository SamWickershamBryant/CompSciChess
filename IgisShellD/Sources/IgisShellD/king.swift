import Igis

class King : Piece {
    
    init(_ color:String) {
        super.init(color)
        self.type = "k"

        self.imageLinkWhite = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Chess_klt45.svg/50px-Chess_klt45.svg.png"
        self.imageLinkBlack = "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Chess_kdt45.svg/50px-Chess_kdt45.svg.png"
    }
    
    override func moveList(boardstate:[[Piece?]]) -> [Point] {
        return parseKingMoves(boardstate:boardstate)
    }

    override func legalMoves(boardstate:[[Piece?]]) -> [Point] {
        return moveList(boardstate:boardstate).filter({!Board.moveLeavesKingInDanger(from:self.position, to:$0, boardstate:boardstate)})
    }




}
