import Igis

class Knight : Piece {



    
    init(_ color:String) {
        super.init(color)
        self.type = "n"
    }
    
    override func moveList(boardstate:[[Piece?]]) -> [Point] {
        let unfilteredLegalMoves = [Point(x:self.position.x-2,y:self.position.y-1),Point(x:self.position.x-1,y:self.position.y-2),
                                    Point(x:self.position.x+2,y:self.position.y-1),Point(x:self.position.x+1,y:self.position.y-2),
                                    Point(x:self.position.x-2,y:self.position.y+1),Point(x:self.position.x-1,y:self.position.y+2),
                                    Point(x:self.position.x+2,y:self.position.y+1),Point(x:self.position.x+1,y:self.position.y+2)]
        return unfilteredLegalMoves.filter({Board.inBounds($0)})
    }

    override func legalMoves(boardstate:[[Piece?]]) -> [Point] {
        // only have to check if the king gets put in danger because knight jumps high as a mf
        return moveList()
    }


}
