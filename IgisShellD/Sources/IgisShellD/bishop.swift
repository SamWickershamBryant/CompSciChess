import Igis

class Bishop : Piece {



    
    init(_ color:String) {
        super.init(color)
        self.type = "b"
    }

    
 
    override func moveList() -> [Point] {
        var unfilteredLegalMoves = [Point]()
        for spaces in 1...7{
        unfilteredLegalMoves.append(Point(x:self.position.x+spaces,y:self.position.y+spaces))
        unfilteredLegalMoves.append(Point(x:self.position.x+spaces,y:self.position.y-spaces))
        unfilteredLegalMoves.append(Point(x:self.position.x-spaces,y:self.position.y-spaces))
        unfilteredLegalMoves.append(Point(x:self.position.x-spaces,y:self.position.y+spaces))
        }
        return unfilteredLegalMoves.filter({Board.inBounds($0)})
    }

    override func legalMoves(boardstate:[[Piece?]]) -> [Point] {
        return parseBishopMoves(boardstate:boardstate)
    }






}
