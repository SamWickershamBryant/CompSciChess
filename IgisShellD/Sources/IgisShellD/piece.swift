import Igis

class Piece : CustomStringConvertible {

    let type : String
    let color : String // "b" or "w"
    var position : Point
    var hasMoved : Bool
    
    init(type:String, color:String, position: Point, hasMoved: Bool) {
        self.type = type
        self.color = color
        self.position = position
        self.hasMoved = hasMoved
    }

   
    func id() -> String {
        return "Color: \(self.color), Type: \(self.type), \(position)" 
    }

    func legalMoves(pos:Point, boardState: [[Piece?]],
                    enPassantTargets: [Point], unMovedPawns:[Point], castleReady:[Point]) -> [Point] {
        
        guard Board.inBounds(pos) == false else {
            print("The point is not in bounds")
            return []
        }
        guard Board.pieceAt(pos, boardstate:boardState) != nil else {
            print("No piece at position : \(pos)")
            return []
        }

        var legalMoves = [Point]()
        var unfilteredLegalMoves = [Point]()
        
        let piece = Board.pieceAt(pos,boardstate:boardState)
        let piecePos = pos
        // just use position given

        // Legal moves for knight
        if piece!.type == "n" {
            
            unfilteredLegalMoves = [Point(x:piecePos.x-2,y:piecePos.y-1),Point(x:piecePos.x-1,y:piecePos.y-2),
                                    Point(x:piecePos.x+2,y:piecePos.y-1),Point(x:piecePos.x+1,y:piecePos.y-2),
                                    Point(x:piecePos.x-2,y:piecePos.y+1),Point(x:piecePos.x-1,y:piecePos.y+2),
                                    Point(x:piecePos.x+2,y:piecePos.y+1),Point(x:piecePos.x+1,y:piecePos.y+2)]

            // Legal moves for rook
        } else if piece!.type == "r" {
            for xy in 1...7 {
                unfilteredLegalMoves.append(Point(x:piecePos.x,y:piecePos.y+xy))
                unfilteredLegalMoves.append(Point(x:piecePos.x-xy,y:piecePos.y))
                unfilteredLegalMoves.append(Point(x:piecePos.x,y:piecePos.y-xy))
                unfilteredLegalMoves.append(Point(x:piecePos.x+xy,y:piecePos.y))
            }
            // Legal moves for Bishop
        } else if piece!.type == "b" {
            for xy in 1...7 {
                unfilteredLegalMoves.append(Point(x:piecePos.x+xy,y:piecePos.y-xy))
                unfilteredLegalMoves.append(Point(x:piecePos.x-xy,y:piecePos.y-xy))
                unfilteredLegalMoves.append(Point(x:piecePos.x+xy,y:piecePos.y+xy))
                unfilteredLegalMoves.append(Point(x:piecePos.x-xy,y:piecePos.y+xy))
            }
            // Legal moves for Queen
        } else if piece!.type == "q" {
            for xy in 1...7 {
                unfilteredLegalMoves.append(Point(x:piecePos.x+xy,y:piecePos.y-xy))
                unfilteredLegalMoves.append(Point(x:piecePos.x-xy,y:piecePos.y-xy))
                unfilteredLegalMoves.append(Point(x:piecePos.x+xy,y:piecePos.y+xy))
                unfilteredLegalMoves.append(Point(x:piecePos.x-xy,y:piecePos.y+xy))
                unfilteredLegalMoves.append(Point(x:piecePos.x,y:piecePos.y+xy))
                unfilteredLegalMoves.append(Point(x:piecePos.x-xy,y:piecePos.y))
                unfilteredLegalMoves.append(Point(x:piecePos.x,y:piecePos.y-xy))
                unfilteredLegalMoves.append(Point(x:piecePos.x+xy,y:piecePos.y))
            }
            // Legal moves for Pawn
        } else if piece!.type == "p" {        
            if piece!.color == "w" {
                unfilteredLegalMoves.append(Point(x:piecePos.x, y:piecePos.y - 1))
                if unMovedPawns.contains(where:{ $0.x == piecePos.x && $0.y == piecePos.y }) {
                    unfilteredLegalMoves.append(Point(x:piecePos.x, y:piecePos.y - 2))
                }
            }
            else if piece!.color == "b" {
                unfilteredLegalMoves.append(Point(x:piecePos.x, y:piecePos.y + 1))
                if unMovedPawns.contains(where:{ $0.x == piecePos.x && $0.y == piecePos.y }) {
                    unfilteredLegalMoves.append(Point(x:piecePos.x, y:piecePos.y + 2)) 
            }
        }
        return []
    }    
    
    var description : String {
        return "Type:\(type), Color:\(color), Position:\(position), hasMoved:\(hasMoved)"
    }
}
