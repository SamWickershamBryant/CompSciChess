import Igis
import Foundation

class Game {

    let board : Board
    let topMargin : Rect
    let bottomMargin : Rect
    let sideBar : Rect

    init(gameSize:Rect) {
        let gameHeight = gameSize.size.height
        let gameWidth = gameSize.size.width
        
        topMargin = Rect(topLeft:Point(x:gameSize.topLeft.x, y:gameSize.topLeft.y),
                         size: Size(width: (gameWidth * 65) / 100, height: gameHeight / 10))
        let boardTopLeft = Point(x:gameSize.topLeft.x,
                                 y:gameSize.topLeft.y + topMargin.size.height)
                
        let boardSize = Size(width:topMargin.size.width, height:topMargin.size.width)
        bottomMargin = Rect(topLeft:Point(x:gameSize.topLeft.x, y:gameSize.topLeft.y + topMargin.size.height + boardSize.height),
                            size:Size(width:topMargin.size.width, height:gameSize.size.height - boardSize.height - topMargin.size.height))
        
        self.board = Board(topLeft:, size:,  boardstate:, whosMove:, outLineColor:, inLinecolor:, squareColor:, lineWidth:)
    }

    func onClick(point:Point) -> Point {
        if point.x < board
    }
}
