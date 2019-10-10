import Igis
import Foundation

class Game {

    let board : Board
    var choosing : Bool
    var choosingPoint : Point
    var boardChanged : Bool

    init() {
        board = Board(topLeft:Point(x:100, y:100), size: 800)
        choosing = false
        choosingPoint = Point(x:0, y:0)
        boardChanged = true
    }

    func setup(canvas:Canvas) {
        board.setPositions(canvas:canvas)
    }

    func isReady() -> Bool {
        print(board.piecesReady())
        return board.piecesReady()
    }

    func needsToRender() -> Bool {
        return boardChanged
    }

    func renderGame(canvas:Canvas) {
        board.renderBoard(canvas:canvas)
        if choosing == true {
            board.renderMoves(of:choosingPoint, canvas:canvas)
        }
        board.renderPiecesAsImage(canvas:canvas)
        boardChanged = false
    }

    func clickPosition(point:Point) -> Point {
        let squareSize = board.size / 8
        let chessX = (point.x - board.topLeft.x) / squareSize
        let chessY = (point.y - board.topLeft.y) / squareSize
        return Point(x:chessX,y:chessY)
    }

    func clickOnBoard(point:Point) -> Bool {
        return (point.x > board.topLeft.x) &&
          (point.x < (board.topLeft.x + board.size)) &&
          (point.y > board.topLeft.y) &&
          (point.y < (board.topLeft.y + board.size))
    }

    func onClick(point:Point) {
        guard clickOnBoard(point:point) else {
            choosing = false
            boardChanged = true
            return
        }
        let pos = clickPosition(point:point)
        guard Board.inBounds(pos) else {
            print("you shouldnt see this message owO")
            return
        }
        if choosing == false {
            if Board.pieceAt(pos, boardstate:board.boardstate) == nil {
                choosing = false
                boardChanged = true
            } else {
                choosing = true
                choosingPoint = pos
                boardChanged = true
            }
        } else {
            let legalMoves = board.legalMoves(of:choosingPoint)
            if legalMoves.contains(where:{$0.x == pos.x && $0.y == pos.y}) {
                board.movePiece(from:choosingPoint, to:pos)
                choosing = false
                boardChanged = true
            } else {
                choosing = false
                boardChanged = true
            }
        }
        
    }

    
}
