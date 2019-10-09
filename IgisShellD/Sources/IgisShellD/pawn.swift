import Igis
import Foundation
class Pawn : Piece {



    
    init(_ color:String) {
        super.init(color)
        self.type = "p"
    }

    
    override func moveList(boardstate:[[Piece?]]) -> [Point] {
        var attackMoves : [Point] = []
        var passiveMoves : [Point] = []
        if self.color == "w" {
        let forward1 = Point(x:self.position.x, y:self.position.y - 1)
        let forward2 = Point(x:self.position.x, y:self.position.y - 2)
        let upLeft = Point(x:self.position.x - 1, y:self.position.y - 1)
        let upRight = Point(x:self.position.x + 1, y:self.position.y - 1)
        if Board.pieceAt(forward1, boardstate:boardstate) == nil {
            passiveMoves.append(forward1)
            if Board.pieceAt(forward2, boardstate:boardstate) == nil && self.hasMoved == false {
                passiveMoves.append(forward2)
            }
        }
        let upLeftPiece = Board.pieceAt(upLeft, boardstate:boardstate)
        let upRightPiece = Board.pieceAt(upRight, boardstate:boardstate)
        if upLeftPiece != nil {
            if upLeftPiece!.color == "b" {
                attackMoves.append(upLeft)
            }
        }
        } else if self.color == "b" {
            let forward1 = Point(x:self.position.x, y:self.position.y + 1)
            let forward2 = Point(x:self.position.x, y:self.position.y + 2)
            let upLeft = Point(x:self.position.x - 1, y:self.position.y + 1)
            let upRight = Point(x:self.position.x + 1, y:self.position.y + 1)
        }
       
        
    }

    override func legalMoves(boardstate:[[Piece?]]) -> [Point] {
        return []
    }

    
}
