import Igis

class Piece {

    let type : String
    let color : String // "b" or "w"
    var hasMoved : Bool

    //global piece variable, this makes it so every in every board, duplicate pieces have the same address and therefore if compared Piece.wPawn == Piece.wPawn : true.
    //To check what type a piece is it is simply Piece.wPawn.type or .id()
    static let wPawn = Piece(type:"p", color:"w")
    static let wRook = Piece(type:"r", color:"w")
    static let wKnight = Piece(type:"n", color:"w")
    static let wBishop = Piece(type:"b", color:"w")
    static let wQueen = Piece(type:"q", color:"w")
    static let wKing = Piece(type:"k", color:"w")

    static let bPawn = Piece(type:"p", color:"b")
    static let bRook = Piece(type:"r", color:"b")
    static let bKnight = Piece(type:"n", color:"b")
    static let bBishop = Piece(type:"b", color:"b")
    static let bQueen = Piece(type:"q", color:"b")
    static let bKing = Piece(type:"k", color:"b")

    
    init(type:String, color:String) {
        self.type = type
        self.color = color
    }

    func id() -> String {
        return "Color: \(self.color), Type: \(self.type)" 
    }

    func legalMoves(pos:Point, boardState: [[Piece?]]) -> [Point] {
        
        // Is the point in bounds
        guard Board.inBounds(pos) == false else {
            print("The point is not in bounds")
            return []
        }        
        // Is there is a piece        
        guard Board.pieceAt(pos, boardstate:boardState) != nil else {
            print("No piece at position : \(pos)")
            return []
        }
        
        var legalMoves = [Point]()
        var unfilteredLegalMoves = [Point]()

        
        let piece = Board.pieceAt(pos,boardstate:boardState)
        let piecePos = Board.findPiece(piece!, boardstate:boardState)[0]
        
        // Legal moves for knight
        if piece!.type == "n" {
                                       //Top left                            
            unfilteredLegalMoves =    [Point(x:piecePos.x-2,y:piecePos.y-1),Point(x:piecePos.x-1,y:piecePos.y-2),
                                       //Top right
                                       Point(x:piecePos.x+2,y:piecePos.y-1),Point(x:piecePos.x+1,y:piecePos.y-2),
                                       //Bottom left
                                       Point(x:piecePos.x-2,y:piecePos.y+1),Point(x:piecePos.x-1,y:piecePos.y+2),
                                       //Bottom right
                                       Point(x:piecePos.x+2,y:piecePos.y+1),Point(x:piecePos.x+1,y:piecePos.y+2)]




            

            // If you guys know any way to shorten these garbage ass appends lmk or just do em


            
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
        }
        
        return []
    }







    

}
