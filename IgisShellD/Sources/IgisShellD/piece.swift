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

    static var image : [String : Image?] = ["p":nil,
                                            "r":nil,
                                            "n":nil,
                                            "b":nil,
                                            "k":nil,
                                            "q":nil,
                                            "P":nil,
                                            "R":nil,
                                            "N":nil,
                                            "B":nil,
                                            "K":nil,
                                            "Q":nil
    ]

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

    func displayImage(rect:Rect, canvas:Canvas) {
        if imageReady() {
            Piece.image[fenType()]!!.renderMode = .destinationRect(rect)
            canvas.render(Piece.image[fenType()]!!)
        } else {
            print("the image is not ready yet")
        }
    }

    func imageReady() -> Bool {
        if Piece.image[fenType()]! != nil {
            return Piece.image[fenType()]!!.isReady
        } else {
            print("please load the image retard")
            return false
        }
    }

    func loadImage(canvas:Canvas) {
        if Piece.image[fenType()]! == nil {
            Piece.image[fenType()]! = (imageDisplay()) as Image?
            canvas.setup(Piece.image[fenType()]!!)
            print("load image \(fenType()) <-")
        }
        
    }

    func imageDisplay() -> Image {
        if self.color == "b" {
            guard let url =
                    URL(string:imageLinkBlack) else {
                fatalError("failed to create URL for \(self.type) \(self.color)")
            }
            return Image(sourceURL:url)
        }else {
            guard let url =
                    URL(string:imageLinkWhite)
            
            else {
                fatalError("failed to create URL for \(self.type) \(self.color)")
            }

            return Image(sourceURL:url)
        }
        
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
        return "\(color)\(type)"
        
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

