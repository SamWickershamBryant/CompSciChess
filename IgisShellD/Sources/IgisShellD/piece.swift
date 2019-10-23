import Igis
import Foundation
class Piece : CustomStringConvertible {


    let color : String // "b" or "w"
    var position : Point
    var hasMoved : Bool
    var type: String = ""

    var imageLinkWhite : String = ""
    var imageLinkBlack : String = ""

    var enPassantTarget : Bool // for pawns only

    func fenType() -> String {
        if self.color == "b" {
            return type.uppercased()
        } else {
            return type
        }
    }
             
    
    init(_ color:String, position: Point = Point(x:-1, y:-1), hasMoved: Bool = false) {
        
        self.color = color
        self.position = position
        self.hasMoved = hasMoved
        self.enPassantTarget = false
        
    }

    func textDisplay(location:Point, fontSize:Int) -> Text {
        let letter = Text(location:location, text:"\(self.type)\(self.position.x)\(self.position.y)")
        letter.font = "\(String(fontSize))pt Helvetica"
        return letter
    }

    func parseBishopMoves(boardstate:[[Piece?]]) -> [Point] {

        var unfilteredLegalMoves = [Point]()

        for tlSpaces in 1 ... 7 {
            // y --, x --
            let point = Point(x:self.position.x - tlSpaces, y:self.position.y - tlSpaces)
            if !Board.inBounds(point) {
                break
            } else {
                let pendingLocation : Piece? = Board.pieceAt(point, boardstate:boardstate)
                if pendingLocation == nil {
                    unfilteredLegalMoves.append(point)
                } else if !(pendingLocation!.color == self.color) {
                    unfilteredLegalMoves.append(point)
                    break
                } else {
                    break
                }
            }
        }

        for trSpaces in 1 ... 7 {
            // y --, x ++
            let point = Point(x:self.position.x + trSpaces, y:self.position.y - trSpaces)
            if !Board.inBounds(point) {
                break
            } else {
                let pendingLocation : Piece? = Board.pieceAt(point, boardstate:boardstate)
                if pendingLocation == nil {
                    unfilteredLegalMoves.append(point)
                } else if !(pendingLocation!.color == self.color) {
                    unfilteredLegalMoves.append(point)
                    break
                } else {
                    break
                }
            }
        }

        for blSpaces in 1 ... 7 {
            // y ++, x --
            let point = Point(x:self.position.x - blSpaces, y:self.position.y + blSpaces)
            if !Board.inBounds(point) {
                break
            } else {
                let pendingLocation : Piece? = Board.pieceAt(point, boardstate:boardstate)
                if pendingLocation == nil {
                    unfilteredLegalMoves.append(point)
                } else if !(pendingLocation!.color == self.color) {
                    unfilteredLegalMoves.append(point)
                    break
                } else {
                    break
                }
            }
        }

        for brSpaces in 1 ... 7 {
            // y ++, x ++
            let point = Point(x:self.position.x + brSpaces, y:self.position.y + brSpaces)
            if !Board.inBounds(point) {
                break
            } else {
                let pendingLocation : Piece? = Board.pieceAt(point, boardstate:boardstate)
                if pendingLocation == nil {
                    unfilteredLegalMoves.append(point)
                } else if !(pendingLocation!.color == self.color) {
                    unfilteredLegalMoves.append(point)
                    break
                } else {
                    break
                }
            }
        }
        
        return unfilteredLegalMoves
        
    }
    func parseKingMoves(boardstate:[[Piece?]]) -> [Point] {
        var unfilteredLegalMoves = [Point]()

        let kingPiece = Board.pieceAt(Board.findPiece(self.color,"k",boardstate:boardstate)[0],boardstate:boardstate)        
        
        //tm        
        unfilteredLegalMoves.append(Point(x:kingPiece!.position.x,y:kingPiece!.position.y-1))
        //tl
        unfilteredLegalMoves.append(Point(x:kingPiece!.position.x-1,y:kingPiece!.position.y-1))
        //tr
        unfilteredLegalMoves.append(Point(x:kingPiece!.position.x+1,y:kingPiece!.position.y-1))

        //ml
        unfilteredLegalMoves.append(Point(x:kingPiece!.position.x-1,y:kingPiece!.position.y))
        //mr
        unfilteredLegalMoves.append(Point(x:kingPiece!.position.x+1,y:kingPiece!.position.y)) 

        //mb
        unfilteredLegalMoves.append(Point(x:kingPiece!.position.x,y:kingPiece!.position.y+1))
        //bl
        unfilteredLegalMoves.append(Point(x:kingPiece!.position.x-1,y:kingPiece!.position.y+1))
        //br
        unfilteredLegalMoves.append(Point(x:kingPiece!.position.x+1,y:kingPiece!.position.y+1))

        var finalUnfilteredLegalMoves : [Point] = []
        
        for move in unfilteredLegalMoves {
            if Board.inBounds(move) == true {            
                if Board.pieceAt(move, boardstate:boardstate) == nil {
                    finalUnfilteredLegalMoves.append(move)
                } else {
                    if Board.pieceAt(move, boardstate:boardstate)!.color != self.color {
                        finalUnfilteredLegalMoves.append(move)
                    }
                }
            }
        }
        return finalUnfilteredLegalMoves        
    }    
    func parseKingCastleMoves(boardstate:[[Piece?]]) -> [Point] {
        
        // Castle rights --------------------------------------------------
        let kingPiece = Board.pieceAt(Board.findPiece(self.color,"k",boardstate:boardstate)[0],boardstate:boardstate)
        var finalUnfilteredLegalMoves = [Point]()
        
        // enemy moves
        var enemyMoves = [Point]()        
        for i in 0...7 {
            for j in 0...7 {
                if boardstate[i][j] != nil {
                    if boardstate[i][j]!.color != kingPiece!.color {
                        for move in boardstate[i][j]!.moveList(boardstate:boardstate) {
                            enemyMoves.append(move)
                        }
                    }
                }
            }
        }
        
        var count = 0        
        if kingPiece!.hasMoved == false {
            // white castle
            if self.color == "w" {

                // left side castle
                for i in 1..<4 {
                    if boardstate[kingPiece!.position.y][kingPiece!.position.x-i] == nil {
                        for move in enemyMoves {                            
                            if move.x != boardstate[kingPiece!.position.y][kingPiece!.position.x-i]!.position.x
                            && move.y != boardstate[kingPiece!.position.y][kingPiece!.position.x-i]!.position.y {                                
                                count += 1
                            }
                        }
                    } else {
                        break
                    }
                }
                // if there are no obstructing pieces
                if count == 3  {
                    // if rook has moved
                    if boardstate[kingPiece!.position.y][kingPiece!.position.x-4]!.type == "r" {
                        if boardstate[kingPiece!.position.y][kingPiece!.position.x-4]!.hasMoved == false {                            
                            finalUnfilteredLegalMoves.append(Point(x:kingPiece!.position.x-2,y:kingPiece!.position.y))
                        }
                    }
                }
                // end of left white castle

                // right side castle
                for i in 1..<3 {
                    if boardstate[kingPiece!.position.y][kingPiece!.position.x+i] == nil {
                        for move in enemyMoves {                            
                            if move.x != boardstate[kingPiece!.position.y][kingPiece!.position.x+i]!.position.x
                            && move.y != boardstate[kingPiece!.position.y][kingPiece!.position.x+i]!.position.y {        
                                count += 1
                            }
                        }
                    } else {
                        break
                    }
                }
                // if there are no obstructing pieces
                if count == 2  {
                    // if rook has moved
                    if boardstate[kingPiece!.position.y][kingPiece!.position.x+3]!.type == "r" {
                        // if rook has not moved
                        if boardstate[kingPiece!.position.y][kingPiece!.position.x+3]!.hasMoved == false {
                            finalUnfilteredLegalMoves.append(Point(x:kingPiece!.position.x+2,y:kingPiece!.position.y))
                        }
                    }
                }            
                // end of right white castle

            // Black Castle
            } else if self.color == "b" {

                // left side black castle
                for i in 1..<4 {
                    if boardstate[kingPiece!.position.y][kingPiece!.position.x-i] == nil {
                        for move in enemyMoves {
                            if move.x != boardstate[kingPiece!.position.y][kingPiece!.position.x-i]!.position.x
                            && move.y != boardstate[kingPiece!.position.y][kingPiece!.position.x-i]!.position.y {        
                                count += 1
                            }
                        }
                    } else {
                        break
                    }
                }
                if count == 3  {
                    if boardstate[kingPiece!.position.y][kingPiece!.position.x-4]!.type == "r" { 
                        if boardstate[kingPiece!.position.y][kingPiece!.position.x-4]!.hasMoved == false {
                            finalUnfilteredLegalMoves.append(Point(x:kingPiece!.position.x-2,y:kingPiece!.position.y))
                        }
                    }
                }
                // end of left side castle
                
                // right side black castle
                for i in 1..<3 {
                    if boardstate[kingPiece!.position.y][kingPiece!.position.x+i] == nil {
                        for move in enemyMoves {                            
                            if move.x != boardstate[kingPiece!.position.y][kingPiece!.position.x+i]!.position.x
                            && move.y != boardstate[kingPiece!.position.y][kingPiece!.position.x+i]!.position.y {        
                                count += 1
                            }
                        }
                    } else {
                        break
                    }
                }
                if count == 2 {
                    if boardstate[kingPiece!.position.y][kingPiece!.position.x+3]!.type == "r" {
                        if boardstate[kingPiece!.position.y][kingPiece!.position.x+3]!.hasMoved == false {
                            finalUnfilteredLegalMoves.append(Point(x:kingPiece!.position.x+2,y:kingPiece!.position.y))
                        }
                    }
                }
                // end of right black castle
            }    
        }
        // End of Castle Rights ------------------------------------------------------------------------------------


        return finalUnfilteredLegalMoves
        // yugi split these hoes up, its causing errors with the board
    }
    
    func parseRookMoves(boardstate:[[Piece?]]) -> [Point] {
        var unfilteredLegalMoves = [Point]()

        for uSpaces in 1 ... 7 {
            // y --
            let point = Point(x:self.position.x, y:self.position.y - uSpaces)
            if !Board.inBounds(point) {
                break
            } else {
                let pendingLocation : Piece? = Board.pieceAt(point, boardstate:boardstate)
                if pendingLocation == nil {
                    unfilteredLegalMoves.append(point)
                } else if !(pendingLocation!.color == self.color) {
                    unfilteredLegalMoves.append(point)
                    break
                } else {
                    break
                }
            }
        }

        for dSpaces in 1 ... 7 {
            // y ++
            let point = Point(x:self.position.x, y:self.position.y + dSpaces)
            if !Board.inBounds(point) {
                break
            } else {
                let pendingLocation : Piece? = Board.pieceAt(point, boardstate:boardstate)
                if pendingLocation == nil {
                    unfilteredLegalMoves.append(point)
                } else if !(pendingLocation!.color == self.color) {
                    unfilteredLegalMoves.append(point)
                    break
                } else {
                    break
                }
            }
        }

        for lSpaces in 1 ... 7 {
            // x --
            let point = Point(x:self.position.x - lSpaces, y:self.position.y)
            if !Board.inBounds(point) {
                break
            } else {
                let pendingLocation : Piece? = Board.pieceAt(point, boardstate:boardstate)
                if pendingLocation == nil {
                    unfilteredLegalMoves.append(point)
                } else if !(pendingLocation!.color == self.color) {
                    unfilteredLegalMoves.append(point)
                    break
                } else {
                    break
                }
            }
        }

        for rSpaces in 1 ... 7 {
            // x ++
            let point = Point(x:self.position.x + rSpaces, y:self.position.y)
            if !Board.inBounds(point) {
                break
            } else {
                let pendingLocation : Piece? = Board.pieceAt(point, boardstate:boardstate)
                if pendingLocation == nil {
                    unfilteredLegalMoves.append(point)
                } else if !(pendingLocation!.color == self.color) {
                    unfilteredLegalMoves.append(point)
                    break
                } else {
                    break
                }
            }
        }

        return unfilteredLegalMoves
        
    }

    

    

   
    func id() -> String {
        return "Color: \(self.color), Type: \(self.type), \(position)" 
    }

    func moveList(boardstate:[[Piece?]]) -> [Point] {
        print("Overwrite this function.")
        return []
        
    }

    func legalMoves(boardstate:[[Piece?]]) -> [Point] {
        print("Overwrite this function.")
        return []
    }
    
    var description : String {
        return "Piece:\(color)\(type)"
        
    }
}
                   
        /*
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
*/  

