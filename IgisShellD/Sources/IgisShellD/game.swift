import Igis
import Foundation

class Game {

    let board : Board
    var choosing : Bool
    var choosingPoint : Point
    

    var gameState : Int
                                

    var users: [Int]

    

    init(users:[Int]) {
        board = Board()
        choosing = false
        choosingPoint = Point(x:0, y:0)

        gameState = 0
        self.users = users
    }

    func boardChanged() {
        gameState += 1
    }

    

    func setup() {
        board.setPositions()
        boardChanged()
    }

    func isReady(imageLibrary:ImageLibrary) -> Bool {
        print(board.piecesReady(imageLibrary:imageLibrary))
        return board.piecesReady(imageLibrary:imageLibrary)
    }


    func renderGame(imageLibrary:ImageLibrary, boardSettings:BoardSettings, canvas:Canvas) {
        board.renderBoard(boardSettings:boardSettings, canvas:canvas)
        if choosing == true {
            board.renderMoves(of:choosingPoint, boardSettings:boardSettings, canvas:canvas)
        }
        board.renderPiecesAsImage(imageLibrary:imageLibrary, boardSettings:boardSettings, canvas:canvas)

    }

    func clickPosition(boardSettings:BoardSettings, point:Point) -> Point {
        let squareSize = boardSettings.size / 8
        let chessX = (point.x - boardSettings.topLeft.x) / squareSize
        let chessY = (point.y - boardSettings.topLeft.y) / squareSize
        return Point(x:chessX,y:chessY)
    }

    func clickOnBoard(boardSettings:BoardSettings, point:Point) -> Bool {
        return (point.x > boardSettings.topLeft.x) &&
          (point.x < (boardSettings.topLeft.x + boardSettings.size)) &&
          (point.y > boardSettings.topLeft.y) &&
          (point.y < (boardSettings.topLeft.y + boardSettings.size))
    }

    func onClick(boardSettings:BoardSettings, point:Point, userId:Int) {
        guard users.contains(userId) else {
            print("you aint a user cuh")
            return
        }
        guard clickOnBoard(boardSettings:boardSettings, point:point) else {
            choosing = false
            boardChanged()
            return
        }
        let pos = clickPosition(boardSettings:boardSettings, point:point)
        guard Board.inBounds(pos) else {
            print("you shouldnt see this message owO")
            return
        }
        if choosing == false {
            if Board.pieceAt(pos, boardstate:board.boardstate) == nil {
                choosing = false
                boardChanged()
            } else {
                choosing = true
                choosingPoint = pos
                boardChanged()
            }
        } else {
            let legalMoves = board.legalMoves(of:choosingPoint)
            if legalMoves.contains(where:{$0.x == pos.x && $0.y == pos.y}) {
                board.movePiece(from:choosingPoint, to:pos)
                choosing = false
                boardChanged()
            } else {
                choosing = false
                boardChanged()
            }
        }
        
    }

    
}
