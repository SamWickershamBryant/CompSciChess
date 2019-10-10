import Igis

class Board {

    var topLeft : Point 
    var size : Int
    let outLineColor : Color
    let inLineColor : Color
    let squareColor : [Color]
    let lineWidth : Int        
    var boardstate : [[Piece?]]
    var enPassant : [Point]
    var whosMove : String
    var kingInCheck : Bool

    static let defaultBoardstate = [[Rook("b"), Knight("b"), Bishop("b"), Queen("b"), King("b"), Bishop("b"), Knight("b"), Rook("b")],
                                    [Pawn("b"),Pawn("b"),Pawn("b"),Pawn("b"),Pawn("b"),Pawn("b"),Pawn("b"),Pawn("b")],
                                    [nil, nil, nil, nil, nil, nil, nil, nil],
                                    [nil, nil, nil, Queen("w"), Bishop("b"), King("b"), nil, nil],
                                    [nil, nil, Rook("w"), nil, nil, nil, nil, nil],
                                    [nil, nil, nil, nil, nil, nil, nil, nil],
                                    [Pawn("w"),Pawn("w"),Pawn("w"),Pawn("w"),Pawn("w"),Pawn("w"),Pawn("w"),Pawn("w")],
                                    [Rook("w"), Knight("w"), Bishop("w"), Queen("w"), King("w"), Bishop("w"), Knight("w"), Rook("w")],

    ]

    func debug() {
        print("true:\(Board.moveLeavesKingInDanger(from:Point(x:4,y:3), to:Point(x:4,y:2), boardstate:boardstate))")
        print("false:\(Board.moveLeavesKingInDanger(from:Point(x:5,y:3), to:Point(x:5,y:2), boardstate:boardstate))")
        print("true:\(Board.moveLeavesKingInDanger(from:Point(x:5,y:3), to:Point(x:5,y:5), boardstate:boardstate))")
    }
    
          
    init(topLeft:Point, size:Int, boardstate:[[Piece?]] = Board.defaultBoardstate, whosMove : String = "w",
         outLineColor:Color = Color(.black), inLineColor:Color = Color(.black), squareColor:[Color] = [Color(.gray), Color(.royalblue)],
         lineWidth:Int = 2){
        self.topLeft = topLeft
        self.size = size // input not sanitized... yet (MUST be divisible by 8)
        self.boardstate = boardstate
        self.outLineColor = outLineColor
        self.inLineColor = inLineColor
        self.squareColor = squareColor
        self.lineWidth = lineWidth
        self.enPassant = []
        self.whosMove = whosMove
        self.kingInCheck = false
    }
 
    func setPositions() {
        for row in 0 ... 7 {
            for piece in 0 ... 7 {
                let currentPiece = boardstate[row][piece]
                if currentPiece != nil {
                    currentPiece!.position = Point(x:piece, y:row)
                }
            }
        }
    }

    
    
    static func pieceAt(_ position:Point, boardstate: [[Piece?]]) -> Piece? {        
        if boardstate[position.y][position.x] == nil {
            return nil
        } else {
            return boardstate[position.y][position.x]!
        }
    } 
    static func findPiece(_ color:String,_ type:String, boardstate: [[Piece?]]) -> [Point]{
        
        var positions : [Point] = []
        for row in 0...7 {
            for element in 0...7 {
                if boardstate[row][element] != nil {
                    if boardstate[row][element]!.type == type &&
                         boardstate[row][element]!.color == color {
                        positions.append (boardstate[row][element]!.position)
                    }
                }
            }
        }
        return positions
    }
    // This will display the board without having to use images
    func displayBoard() {
        print("   0   1   2   3   4   5   6   7  ")
        var count = 0
        for row in 0...7 {
            for column in 0...7 {
                if column == 0 {
                    print("\(count)", terminator: " ")
                }
                boardstate[row][column] != nil ? print(" \(boardstate[row][column]!.color)\(boardstate[row][column]!.type) ",terminator: " ") : print(" - ", terminator: " ")
            }            
            print("\n")
            count += 1
        }
    }    
    func alivePieces(side:String) -> [Piece] { 
        var whitePieces = [Piece]()
        for row in 0...7 {
            for column in 0...7 {
                let piece = boardstate[row][column]
                if piece != nil {
                    if piece!.color == side {
                        whitePieces.append(piece!)
                    }
                }
            }
        }
        return whitePieces
    }
    static func inBounds(_ pos:Point) -> Bool {
        return pos.x <= 7 && pos.y <= 7 && pos.x >= 0 && pos.y >= 0
    }
       
    func movePiece(from:Point, to:Point) {
        guard Board.inBounds(from) != false else {
            print("Starting piece out of bounds")
            return
        }
        guard Board.pieceAt(from,boardstate:boardstate) != nil else {
            print("No piece at pos: \(from.x),\(from.y)")
            return
        }
        guard Board.inBounds(to) != false else {
            print("Move to pos is out of bounds")
            return
        }
        if enPassant.count > 0 {
            for point in enPassant {
                boardstate[point.y][point.x]!.enPassantTarget = false
            }
            enPassant = []
        }
        
        
        let piece = Board.pieceAt(from,boardstate:boardstate)

        if piece!.type != "p" {
            if Board.pieceAt(Point(x:to.x,y:to.y),boardstate:boardstate) != nil {
                // if a pieces point is -1,-1 its considered "dead"            
                Board.pieceAt(Point(x:to.x,y:to.y),boardstate:boardstate)!.position = Point(x:-1,y:-1)
            }
        } else { // pawn garbage
            if abs(to.y - from.y) == 2 && abs(to.x - from.x) == 0 {
                piece!.enPassantTarget = true
                enPassant.append(to)
            } else {
                var adder = -1
                if piece!.color == "b" {
                    adder = 1
                }
                let upLeft = to.x - from.x == -1 && to.y - from.y == adder
                let upRight = to.x - from.x == 1 && to.y - from.y == adder
                if upLeft {
                    if Board.pieceAt(to, boardstate:boardstate) == nil {
                        let left = Point(x:to.x, y:from.y)
                        if Board.pieceAt(left, boardstate:boardstate) != nil {
                            if Board.pieceAt(left, boardstate:boardstate)!.enPassantTarget {
                                boardstate[left.y][left.x]!.position = Point(x:-1,y:-1)
                                boardstate[left.y][left.x] = nil
                            }
                        }
                    } else {
                        boardstate[to.y][to.x]!.position = Point(x:-1, y:-1)
                    }
                } 
                else if upRight {
                    if Board.pieceAt(to, boardstate:boardstate) == nil {
                        let right = Point(x:to.x, y:from.y)
                        if Board.pieceAt(right, boardstate:boardstate) != nil {
                            if Board.pieceAt(right, boardstate:boardstate)!.enPassantTarget {
                                boardstate[right.y][right.x]!.position = Point(x:-1,y:-1)
                                boardstate[right.y][right.x] = nil
                            }
                        }
                    } else {
                        boardstate[to.y][to.x]!.position = Point(x:-1, y:-1)
                    }
                }
            }
        }
        
        piece!.position = Point(x:to.x, y:to.y)
        piece!.hasMoved = true
        boardstate[to.y][to.x] = piece
        boardstate[from.y][from.x] = nil
        
        if  piece!.color == "w" {
            whosMove = "b"
        } else if piece!.color == "b" {
            whosMove = "w"
        }
    }
    
    // moveBoard moves the entire board to a position (topleft = destination)
    func moveBoard(topLeft:Point) {
        self.topLeft = topLeft
    }

    
    func resizeBoard(size:Int) {
        self.size = size
    }

    static func moveLeavesKingInDanger(from:Point, to:Point, boardstate:[[Piece?]]) -> Bool {
        var testBoard = boardstate
        guard Board.inBounds(from) != false else {
            print("Starting piece out of bounds")
            return false
        }
        guard Board.pieceAt(from, boardstate:testBoard) != nil else {
            print("No piece at pos : \(from.x), \(from.y)")
            return false
        }
        guard Board.inBounds(to) != false else {
            print("Move to pos is out of bounds")
            return false
        }
        let piece = Board.pieceAt(from, boardstate:testBoard)
        var enemyTeam = ""
        if piece!.color == "w" {
            enemyTeam = "b"
        } else if piece!.color == "b" {
            enemyTeam = "w"
        }
        
        

        testBoard[to.y][to.x] = piece! 
        testBoard[from.y][from.x] = nil

        
       
        for row in 0 ... 7 {
            for column in 0 ... 7 {
                let thisPiece = testBoard[row][column]
                if thisPiece != nil{
                    if thisPiece!.color == enemyTeam {
                        let moveList = thisPiece!.moveList(boardstate:testBoard)
                        if moveList.filter({
                            Board.pieceAt($0, boardstate:testBoard) != nil}).filter({
                            Board.pieceAt($0, boardstate:testBoard)!.type == "k"}).count > 0 {
                            return true
                        }
                        
                       
                    }
                }
            }
        }

        return false
        

        
    }

    func legalMoves(of:Point) -> [Point] {
        guard Board.inBounds(of) else {
            print("not in bounds: \(of)")
            return []
        }
        guard Board.pieceAt(of, boardstate:boardstate) != nil else {
            print("piece does not exit at \(of)")
            return []
        }
        return Board.pieceAt(of, boardstate:boardstate)!.legalMoves(boardstate:boardstate)
    }

    func renderMoves(of:Point, canvas:Canvas) {
        guard Board.inBounds(of) else {
            print("not in bounds: \(of)")
            return
        }
        let piece = boardstate[of.y][of.x]
        if piece == nil {
            print("cant render moves of empty space!")
            return
        } else {
            let sideLength = size / 8
            
            
            let thisPiecePosOnBoard = Point(x:topLeft.x + (of.x * sideLength) + (sideLength / 2),
                                          y:topLeft.y + (of.y * sideLength) + (sideLength / 2))
            let thisPieceCircle = Ellipse(center: thisPiecePosOnBoard, radiusX: sideLength  / 4, radiusY: sideLength / 4, fillMode:.fill)
            let moveColor = Color(.brown)
            canvas.render(FillStyle(color:moveColor))
            canvas.render(thisPieceCircle)
            let legalMoves = piece!.legalMoves(boardstate:boardstate)
            if legalMoves.count == 0 {
                print("no legal moves!")
            } else {
                for legalMove in legalMoves {
                    let piecePosOnBoard = Point(x:topLeft.x + (legalMove.x * sideLength) + (sideLength / 2),
                                                y:topLeft.y + (legalMove.y * sideLength) + (sideLength / 2))
                    let pieceCircle = Ellipse(center:piecePosOnBoard, radiusX: sideLength / 4, radiusY: sideLength / 4, fillMode:.fill)
                    canvas.render(pieceCircle)
                }
            }
        }
        
    }

    func renderPiecesAsText(canvas:Canvas) {
        let sideLength = size / 8
        for row in 0 ... 7 {
            for piece in 0 ... 7 {
                //boardstate[row][piece]
                let location = Point(x:topLeft.x + (piece * sideLength) + (sideLength / 2),
                                     y:topLeft.y + (row * sideLength) + (sideLength / 2))
                let fontSize = 10
                let pieceToDisplay = boardstate[row][piece]
                if pieceToDisplay != nil {
                    let text = pieceToDisplay!.textDisplay(location:location, fontSize:fontSize)
                    let blackColor = Color(.black)
                    let whiteColor = Color(.white)
                    if pieceToDisplay!.color == "w" {
                        canvas.render(FillStyle(color:whiteColor))
                    } else {
                        canvas.render(FillStyle(color:blackColor))
                    }
                    
                    canvas.render(text)
                }
            }
        }
    }

    func renderBoard(canvas:Canvas) {
        //render squares, then inlines, then outlines in that order
        
         let sideLength = size / 8 // side length of a single square

         //render squares:

        func incrementColor(index: inout Int) {
            if index >= squareColor.count - 1 {
                index = 0
            } else {
                index += 1
            }
        }
        
        var colorIndex = 0
        
        for column in 0 ... 7 {
            for row in 0 ... 7 {
                var __row = row
                if (column % 2 != 0) {
                    __row = 7 - row
                }
                let squareTopLeft = Point(x:topLeft.x + (__row * sideLength),
                                          y:topLeft.y + (column * sideLength))
                
                let rect = Rect(topLeft:squareTopLeft, size:Size(width:sideLength, height:sideLength))
                let rectangle = Rectangle(rect:rect, fillMode: .fill)
                let fillStyle = FillStyle(color:squareColor[colorIndex])
                canvas.render(fillStyle)
                canvas.render(rectangle)
                incrementColor(index:&colorIndex)
                
            }
        }
        //render inLines:
        let inStrokeStyle = StrokeStyle(color:inLineColor)
        canvas.render(inStrokeStyle)
        canvas.render(LineWidth(width:lineWidth))
        for row in 1 ... 7 {
            let verticalLine = Lines(from:Point(x:topLeft.x + (row * sideLength),
                                                y:topLeft.y),
                                     to:Point(x:topLeft.x + (row * sideLength),
                                              y:topLeft.y + size))
            
            canvas.render(verticalLine)
        }

        for collumn in 1 ... 7 {
            let horizontalLine = Lines(from:Point(x:topLeft.x,
                                                  y:topLeft.y + (collumn * sideLength)),
                                       to:Point(x:topLeft.x + size,
                                                y:topLeft.y + (collumn * sideLength)))
            canvas.render(horizontalLine)
        }

        //render outLines:
        let outStrokeStyle = StrokeStyle(color:outLineColor)
        canvas.render(outStrokeStyle)
        canvas.render(LineWidth(width:lineWidth))

        let outRect = Rect(topLeft:topLeft, size:Size(width:size, height:size))
        let outRectangle = Rectangle(rect:outRect, fillMode: .stroke)
        canvas.render(outRectangle)
        
        
        
    }

    

    
    

}
