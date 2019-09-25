import Igis

class Bishop : Piece {

    init() {
        self.type = "b"
    }
 
    override func moveList() -> [Point] {
        let unfilteredLegalMoves = [Point(x:self.position.x+1,y:self.position.y+1),Point(x:self.position.x+1,y:self.position.y-1),
                                    Point(x:self.position.x-1,y:self.position.y-1),Point(x:self.position.x-1,y:self.position.y+1)]
        return unfilteredLegalMoves.filter({Board.inBounds($0)})
    }

    override func legalMoves() -> [Point] {
        return moveList()
    }






}
