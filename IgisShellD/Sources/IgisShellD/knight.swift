import Igis

class Knight : Piece {



    
    init(_ color:String) {
        super.init(color)
        self.type = "n"
    }
    
    override func moveList(boardstate:[[Piece?]]) -> [Point] {
        var unfilteredLegalMoves = [Point(x:self.position.x-2,y:self.position.y-1),Point(x:self.position.x-1,y:self.position.y-2),
                                    Point(x:self.position.x+2,y:self.position.y-1),Point(x:self.position.x+1,y:self.position.y-2),
                                    Point(x:self.position.x-2,y:self.position.y+1),Point(x:self.position.x-1,y:self.position.y+2),
                                    Point(x:self.position.x+2,y:self.position.y+1),Point(x:self.position.x+1,y:self.position.y+2)]
        unfilteredLegalMoves = unfilteredLegalMoves.filter({Board.inBounds($0)})
        var filteredMoves : [Point] = []
        for point in unfilteredLegalMoves {
            if Board.pieceAt(point, boardstate:boardstate) == nil {
                filteredMoves.append(point)
            } else if Board.pieceAt(point, boardstate:boardstate)!.color != self.color {
                filteredMoves.append(point)
            }
        }
        return filteredMoves
    }

    override func legalMoves(boardstate:[[Piece?]]) -> [Point] {
        // only have to check if the king gets put in danger because knight jumps high as a mf
        return moveList(boardstate:boardstate).filter({!Board.moveLeavesKingInDanger(from:self.position, to:$0, boardstate:boardstate)})
    }


}
