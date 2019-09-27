import Igis

class Queen : Piece {

    init() {
        self.type = "q"
    }
    
    override func moveList() -> [Point] {

        var unfilteredLegalMoves : [Point] = []

        for xy in 1 ... 7 {
             unfilteredLegalMoves.append(Point(x:self.position.x+xy,y:self.position.y-xy))
                unfilteredLegalMoves.append(Point(x:self.position.x-xy,y:self.position.y-xy))
                unfilteredLegalMoves.append(Point(x:self.position.x+xy,y:self.position.y+xy))
                unfilteredLegalMoves.append(Point(x:self.position.x-xy,y:self.position.y+xy))
                unfilteredLegalMoves.append(Point(x:self.position.x,y:self.position.y+xy))
                unfilteredLegalMoves.append(Point(x:self.position.x-xy,y:self.position.y))
                unfilteredLegalMoves.append(Point(x:self.position.x,y:self.position.y-xy))
                unfilteredLegalMoves.append(Point(x:self.position.x+xy,y:self.position.y))
        }

        return unfilteredLegalMoves.filter({Board.inBounds($0)})

        
    }

    override func legalMoves(boardstate:[[Piece?]]) -> [Point] {
        
    }

    
}
