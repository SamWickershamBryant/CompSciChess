import Igis

class Board {

   /* var topLeft : Point 
    var size : Int
    let outLineColor : Color
    let inLineColor : Color
    let squareColor : [Color]
    let lineWidth : Int*/        
    var boardstate : [[Piece?]]
    var enPassant : [Point]
    var whosMove : String
    var kingInCheck : Bool

    static func defaultBoardstate() -> [[Piece?]]{return [[Rook("b"), Knight("b"), Bishop("b"), Queen("b"), King("b"), Bishop("b"), Knight("b"), Rook("b")],
                                    [Pawn("b"),Pawn("b"),Pawn("b"),Pawn("b"),Pawn("b"),Pawn("b"),Pawn("b"),Pawn("b")],
                                    [nil, nil, nil, nil, nil, nil, nil, nil],
                                    [nil, nil, nil, nil, nil, nil, nil, nil],
                                    [nil, nil, nil, nil, nil, nil, nil, nil],
                                    [nil, nil, nil, nil, nil, nil, nil, nil],
                                    [Pawn("w"),Pawn("w"),Pawn("w"),Pawn("w"),Pawn("w"),Pawn("w"),Pawn("w"),Pawn("w")],
                                    [Rook("w"), Knight("w"), Bishop("w"), Queen("w"), King("w"), Bishop("w"), Knight("w"), Rook("w")],

                                                  ]}

    func debug() {
        print("true:\(Board.moveLeavesKingInDanger(from:Point(x:4,y:3), to:Point(x:4,y:2), boardstate:boardstate))")
        print("false:\(Board.moveLeavesKingInDanger(from:Point(x:5,y:3), to:Point(x:5,y:2), boardstate:boardstate))")
        print("true:\(Board.moveLeavesKingInDanger(from:Point(x:5,y:3), to:Point(x:5,y:5), boardstate:boardstate))")
    }

    func dupePiece(_ piece:Piece?) -> Piece? {
        guard piece != nil else {
            return nil
        }
        let c = piece!.color

        switch piece!.type {
        case "p": return Pawn(c)
        case "r": return Rook(c)
        case "n": return Knight(c)
        case "b": return Bishop(c)
        case "q": return Queen(c)
        case "k": return King(c)
        default: return Pawn(c)
        }
    }

    func dupeBoardstate(boardstate:[[Piece?]]) -> [[Piece?]] {
        var dupedBoardstate : [[Piece?]] = [[]]
        var dupedRow : [Piece?] = []
        for row in 0 ... 7 {
            
            for piece in 0 ... 7 {
                let dupedPiece = dupePiece(Board.pieceAt(Point(x:piece, y:row), boardstate:boardstate))
                dupedRow.append(dupedPiece)
                
            }
            dupedBoardstate.append(dupedRow)
            dupedRow = []
        }
        return dupedBoardstate
    }
    
          
    init(boardstate:[[Piece?]] = Board.defaultBoardstate(), whosMove : String = "w"){
       
        self.boardstate = boardstate
       
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
        print("STARTING MOVE PIECE")
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
        
        
        
        let piece = Board.pieceAt(from,boardstate:boardstate)


        var needToClear = true
        
        if piece!.type != "p" {
            if Board.pieceAt(Point(x:to.x,y:to.y),boardstate:boardstate) != nil {
                // if a pieces point is -1,-1 its considered "dead"            
                Board.pieceAt(Point(x:to.x,y:to.y),boardstate:boardstate)!.position = Point(x:-1,y:-1)
            }
        } else { // pawn garbage
            if abs(to.y - from.y) == 2 && abs(to.x - from.x) == 0 {
                piece!.enPassantTarget = true
                if enPassant.count > 0 {
                    for point in enPassant {
                        boardstate[point.y][point.x]!.enPassantTarget = false
                    }
                    enPassant = []
                }
                needToClear = false
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
                        print("2 more")
                        if Board.pieceAt(left, boardstate:boardstate) != nil {
                            print("1 more")
                            if Board.pieceAt(left, boardstate:boardstate)!.enPassantTarget {
                                boardstate[left.y][left.x]!.position = Point(x:-1,y:-1)
                                boardstate[left.y][left.x] = nil
                                print("left")
                            }
                        }
                    } else {
                        boardstate[to.y][to.x]!.position = Point(x:-1, y:-1)
                    }
                } 
                else if upRight {
                    print("dont see this")
                    if Board.pieceAt(to, boardstate:boardstate) == nil {
                        let right = Point(x:to.x, y:from.y)
                        if Board.pieceAt(right, boardstate:boardstate) != nil {
                            if Board.pieceAt(right, boardstate:boardstate)!.enPassantTarget {
                                boardstate[right.y][right.x]!.position = Point(x:-1,y:-1)
                                boardstate[right.y][right.x] = nil
                                print("right")
                            }
                        }
                    } else {
                        boardstate[to.y][to.x]!.position = Point(x:-1, y:-1)
                    }
                }
            }
        }
        if needToClear {
            if enPassant.count > 0 {
                for point in enPassant {
                    if boardstate[point.y][point.x] != nil {
                        boardstate[point.y][point.x]!.enPassantTarget = false
                    }
                }
                enPassant = []
            }
        }
        print("reaaaally close")
        piece!.position = Point(x:to.x, y:to.y)
        piece!.hasMoved = true
        boardstate[to.y][to.x] = piece
        boardstate[from.y][from.x] = nil
        print("made it!")
       
        if  piece!.color == "w" {
            //print("black in check: \(inCheck(color:"b"))")
            whosMove = "b"
        } else if piece!.color == "b" {
            whosMove = "w"
        }

        print("FINISH MOVE PIECE")
    }
    
    // moveBoard moves the entire board to a position (topleft = destination)
    

    /*static func moveLeavesKingInDanger2(from:Point, to:Point, boardstate:[[Piece?]]) -> Bool {
        
    }*/
    

    static func moveLeavesKingInDanger(from:Point, to:Point, boardstate:[[Piece?]]) -> Bool {
        print("STARTING DANGER CHECK")
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
                        let moveListTake = moveList.filter({Board.pieceAt($0, boardstate:testBoard) != nil})
                        if moveListTake.filter({
                            Board.pieceAt($0, boardstate:testBoard)!.type == "k"}).count > 0 {
                            print("FINISH DANGER CHECK TRUE")
                            return true
                        }
                        
                       
                    }
                }
            }
        }
        print("FINISH DANGER CHECK FALSE")

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
        print("STARTING LEGAL MOVES")
        return Board.pieceAt(of, boardstate:boardstate)!.legalMoves(boardstate:boardstate)
        
    }

    func renderMoves(of:Point, boardSettings:BoardSettings, canvas:Canvas) {
        print("STARTING RENDER MOVES")
        guard Board.inBounds(of) else {
            print("not in bounds: \(of)")
            return
        }
        let piece = boardstate[of.y][of.x]
        if piece == nil {
            print("cant render moves of empty space!")
            return
        } else {
            let sideLength = boardSettings.size / 8
            
            
            let thisPiecePosOnBoard = Point(x:boardSettings.topLeft.x + (of.x * sideLength) + (sideLength / 2),
                                            y:boardSettings.topLeft.y + (of.y * sideLength) + (sideLength / 2))
            let thisPieceCircle = Ellipse(center: thisPiecePosOnBoard, radiusX: sideLength  / 4, radiusY: sideLength / 4, fillMode:.fill)
            let moveColor = Color(.cornsilk)
            let thisColor = Color(.darkolivegreen)
            canvas.render(FillStyle(color:thisColor))
            canvas.render(thisPieceCircle)
            canvas.render(FillStyle(color:moveColor))
            let legalMoves = piece!.legalMoves(boardstate:boardstate)
            if legalMoves.count == 0 {
                print("no legal moves!")
            } else {
                for legalMove in legalMoves {
                    let piecePosOnBoard = Point(x:boardSettings.topLeft.x + (legalMove.x * sideLength) + (sideLength / 2),
                                                y:boardSettings.topLeft.y + (legalMove.y * sideLength) + (sideLength / 2))
                    let pieceCircle = Ellipse(center:piecePosOnBoard, radiusX: sideLength / 4, radiusY: sideLength / 4, fillMode:.fill)
                    canvas.render(pieceCircle)
                }
            }
        }
        print("FINISH RENDER MOVES")
        
    }

    func piecesReady(imageLibrary:ImageLibrary) -> Bool {
        return imageLibrary.imagesReady()
    }
    
    func renderPiecesAsImage(imageLibrary:ImageLibrary, boardSettings:BoardSettings, canvas:Canvas) {
        let sideLength = boardSettings.size / 8
        for row in 0 ... 7 {
            for piece in 0 ... 7 {
                let boundingRect = Rect(topLeft:Point(x:boardSettings.topLeft.x + (piece * sideLength),
                                                      y:boardSettings.topLeft.y + (row * sideLength)),
                                        size:Size(width:sideLength, height:sideLength))
                let pieceToDisplay = boardstate[row][piece]
                if pieceToDisplay != nil {
                    if imageLibrary.imageReady(pieceToDisplay!) {
                        imageLibrary.displayImage(piece:boardstate[row][piece]!, rect:boundingRect,
                                                  canvas:canvas)
                    } else {
                        print("this piece not ready fam")
                    }
                }
            }
        }
        
    }

    func renderPiecesAsText(boardSettings:BoardSettings,canvas:Canvas) {
        let sideLength = boardSettings.size / 8
        for row in 0 ... 7 {
            for piece in 0 ... 7 {
                //boardstate[row][piece]
                let location = Point(x:boardSettings.topLeft.x + (piece * sideLength) + (sideLength / 2),
                                     y:boardSettings.topLeft.y + (row * sideLength) + (sideLength / 2))
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

    func renderBoard(boardSettings:BoardSettings,canvas:Canvas) {
        //render squares, then inlines, then outlines in that order
        print("finna render the board")
        let sideLength = boardSettings.size / 8 // side length of a single square

         //render squares:

        func incrementColor(index: inout Int) {
            if index >= boardSettings.squareColor.count - 1 {
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
                let squareTopLeft = Point(x:boardSettings.topLeft.x + (__row * sideLength),
                                          y:boardSettings.topLeft.y + (column * sideLength))
                
                let rect = Rect(topLeft:squareTopLeft, size:Size(width:sideLength, height:sideLength))
                let rectangle = Rectangle(rect:rect, fillMode: .fill)
                let fillStyle = FillStyle(color:boardSettings.squareColor[colorIndex])
                canvas.render(fillStyle)
                canvas.render(rectangle)
                incrementColor(index:&colorIndex)
                
            }
        }
        //render inLines:
        let inStrokeStyle = StrokeStyle(color:boardSettings.inLineColor)
        canvas.render(inStrokeStyle)
        canvas.render(LineWidth(width:boardSettings.lineWidth))
        for row in 1 ... 7 {
            let verticalLine = Lines(from:Point(x:boardSettings.topLeft.x + (row * sideLength),
                                                y:boardSettings.topLeft.y),
                                     to:Point(x:boardSettings.topLeft.x + (row * sideLength),
                                              y:boardSettings.topLeft.y + boardSettings.size))
            
            canvas.render(verticalLine)
        }

        for collumn in 1 ... 7 {
            let horizontalLine = Lines(from:Point(x:boardSettings.topLeft.x,
                                                  y:boardSettings.topLeft.y + (collumn * sideLength)),
                                       to:Point(x:boardSettings.topLeft.x + boardSettings.size,
                                                y:boardSettings.topLeft.y + (collumn * sideLength)))
            canvas.render(horizontalLine)
        }

        //render outLines:
        let outStrokeStyle = StrokeStyle(color:boardSettings.outLineColor)
        canvas.render(outStrokeStyle)
        canvas.render(LineWidth(width:boardSettings.lineWidth * 2))

        let outRect = Rect(topLeft:boardSettings.topLeft, size:Size(width:boardSettings.size, height:boardSettings.size))
        let outRectangle = Rectangle(rect:outRect, fillMode: .stroke)
        canvas.render(outRectangle)
        
        
        
    }

    func inCheck(color:String) -> Bool { // color: "w" or "b"
        var friendlyKing = Piece("b")
        for row in 0...7{
            for piece in 0...7{
                if boardstate[row][piece] != nil{
                    if boardstate[row][piece]!.color == color && boardstate[row][piece]!.type == "K"{
                         friendlyKing = boardstate[row][piece]!
                    }
                }
            }
        }
        var inCheck = false
        for row in 0 ... 7 {
            for piece in 0 ... 7 {
                
                if boardstate[row][piece] != nil{
                    if boardstate[row][piece]!.color == "w"{
                        for point in boardstate[row][piece]!.moveList(boardstate:boardstate){
                            
                            if (Board.pieceAt(point, boardstate:boardstate)!.type == friendlyKing.type) && (Board.pieceAt(point, boardstate:boardstate)!.color == friendlyKing.color){
                                inCheck = true
                            }
                        }
                        
                    // <- gives OPTIONAL piece, nil = empty space.
                // check if color is opposite, then if .moveList() (-> [Point]) hits frienly king
                // Board.pieceAt(point, boardstate:boardstate) -> optional piece <- check if it is friendly king, if so return true, if not then false
                    }
                }
            }
            
        }
        return inCheck
    }
   

}
