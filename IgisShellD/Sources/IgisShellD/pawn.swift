import Igis
import Foundation
class Pawn : Piece {

    

    
    init(_ color:String) {
        super.init(color)
        self.type = "p"

        self.imageLinkWhite = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/Chess_plt45.svg/50px-Chess_plt45.svg.png"
        self.imageLinkBlack = "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/Chess_pdt45.svg/50px-Chess_pdt45.svg.png"
        
    }

    
    override func moveList(boardstate:[[Piece?]]) -> [Point] {
        var attackMoves : [Point] = []
        var passiveMoves : [Point] = []
        if self.color == "w" {
            let forward1 = Point(x:self.position.x, y:self.position.y - 1)
            let forward2 = Point(x:self.position.x, y:self.position.y - 2)
            let upLeft = Point(x:self.position.x - 1, y:self.position.y - 1)
            let upRight = Point(x:self.position.x + 1, y:self.position.y - 1)
            if Board.inBounds(forward1) {
                if Board.pieceAt(forward1, boardstate:boardstate) == nil {
                    passiveMoves.append(forward1)
                    if Board.inBounds(forward2) {
                        if Board.pieceAt(forward2, boardstate:boardstate) == nil && self.hasMoved == false {
                            passiveMoves.append(forward2)
                        }
                    }
                }
            }
            if Board.inBounds(upLeft) {
                let upLeftPiece = Board.pieceAt(upLeft, boardstate:boardstate)
                if upLeftPiece != nil {
                    if upLeftPiece!.color == "b" {
                        attackMoves.append(upLeft)
                    }
                    
                } else {
                    let left = Point(x:self.position.x - 1, y:self.position.y)
                    let enPassantTarget = Board.pieceAt(left, boardstate:boardstate)
                    if enPassantTarget != nil {
                        if enPassantTarget!.color == "b" && enPassantTarget!.type == "p" && enPassantTarget!.enPassantTarget == true {
                            attackMoves.append(upLeft)
                        }
                    }
                }
            }
            if Board.inBounds(upRight) {
                let upRightPiece = Board.pieceAt(upRight, boardstate:boardstate)
                if upRightPiece != nil {
                    if upRightPiece!.color == "b" {
                        attackMoves.append(upRight)
                    }
                } else {
                    let right = Point(x:self.position.x + 1, y:self.position.y)
                    let enPassantTarget = Board.pieceAt(right, boardstate:boardstate)
                    if enPassantTarget != nil {
                        if enPassantTarget!.color == "b" && enPassantTarget!.type == "p" && enPassantTarget!.enPassantTarget == true {
                            attackMoves.append(upRight)
                        }
                    }
                }
            }
        } else if self.color == "b" {
            let forward1 = Point(x:self.position.x, y:self.position.y + 1)
            let forward2 = Point(x:self.position.x, y:self.position.y + 2)
            let upLeft = Point(x:self.position.x - 1, y:self.position.y + 1)
            let upRight = Point(x:self.position.x + 1, y:self.position.y + 1)
            if Board.inBounds(forward1) {
                if Board.pieceAt(forward1, boardstate:boardstate) == nil {
                    passiveMoves.append(forward1)
                    if Board.inBounds(forward2) {
                        if Board.pieceAt(forward2, boardstate:boardstate) == nil && self.hasMoved == false {
                            passiveMoves.append(forward2)
                        }
                    }
                }
            }
            if Board.inBounds(upLeft) {
                let upLeftPiece = Board.pieceAt(upLeft, boardstate:boardstate)
                if upLeftPiece != nil {
                    if upLeftPiece!.color == "w" {
                        attackMoves.append(upLeft)
                    }
                    
                } else {
                    let left = Point(x:self.position.x - 1, y:self.position.y)
                    let enPassantTarget = Board.pieceAt(left, boardstate:boardstate)
                    if enPassantTarget != nil {
                        if enPassantTarget!.color == "w" && enPassantTarget!.type == "p" && enPassantTarget!.enPassantTarget == true {
                            attackMoves.append(upLeft)
                        }
                    }
                }
            }
            if Board.inBounds(upRight) {
                let upRightPiece = Board.pieceAt(upRight, boardstate:boardstate)
                if upRightPiece != nil {
                    if upRightPiece!.color == "w" {
                        attackMoves.append(upRight)
                    }
                } else {
                    let right = Point(x:self.position.x + 1, y:self.position.y)
                    let enPassantTarget = Board.pieceAt(right, boardstate:boardstate)
                    if enPassantTarget != nil {
                        if enPassantTarget!.color == "w" && enPassantTarget!.type == "p" && enPassantTarget!.enPassantTarget == true {
                            attackMoves.append(upRight)
                        }
                    }
                }
            }
        }

        return passiveMoves + attackMoves
       
        
    }

    override func legalMoves(boardstate:[[Piece?]]) -> [Point] {
        return moveList(boardstate:boardstate).filter({!Board.moveLeavesKingInDanger(from:self.position, to:$0, boardstate:boardstate)})
    }

    
}
