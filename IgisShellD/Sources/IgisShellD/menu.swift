import Igis
import Foundation

class Menu {
    
    var gameRect : Rect
    var mainRect : Rect //width will be >=65% of gameRect (until divisible by 8)
                        //height will be <=canvasHeight (until divisible by 10))
    var sideBarRect : Rect //width will be <=35% of gameRect (until mainRect divisible by 8)
                           //height will be = mainRect
    
    init(){
        gameRect = Rect(topLeft:Point(x:0, y:0), size:Size(width:50, height:50))
        mainRect = Rect(topLeft:Point(x:10, y:0), size:Size(width:50, height:50))
        sideBarRect = Rect(topLeft:Point(x:20, y:0), size:Size(width:50, height:50))
    }
    
    func setGameRect(canvas:Canvas) -> Rect {
        let updatedMainRect = setMainRect(canvas:canvas)
        let updatedSideBarRect = setSideBarRect(canvas:canvas)
        let updatedGameRect = Rect(topLeft:Point(x:0, y:0),
                                   size:Size(width:updatedMainRect.size.width + updatedSideBarRect.size.width,
                                             height:updatedMainRect.size.height + updatedSideBarRect.size.height))
        return updatedGameRect
    }
    
    func setMainRect(canvas:Canvas) -> Rect {
        var updatedMainRect = mainRect
        if canvas.canvasSize != nil {
            let canvasWidth = canvas.canvasSize!.width
            let canvasHeight = canvas.canvasSize!.height
            var updatedWidth = canvasWidth - ((canvasWidth * 65) / 100)
            while updatedWidth % 8 != 0 {
                updatedWidth += 1
            }
            var updatedHeight = canvasHeight - updatedWidth
            while updatedHeight % 10 != 0 {
                updatedHeight -= 1
            }
            updatedMainRect = Rect(topLeft:Point(x:0, y:0),
                                   size:Size(width:updatedWidth, height:updatedHeight))
        }
        return updatedMainRect
    }

    func setSideBarRect(canvas:Canvas) -> Rect {
        var updatedSideBarRect = mainRect
        if canvas.canvasSize != nil {
            let updatedWidth = gameRect.size.width - mainRect.size.width
            let updatedHeight = mainRect.size.height
            updatedSideBarRect = Rect(topLeft:Point(x:mainRect.topLeft.x + mainRect.size.width, y:mainRect.topLeft.y),
                                      size:Size(width:updatedWidth,
                                                height:updatedHeight))
        }
        return updatedSideBarRect
    }
}




/*
 when board is finished, the future plan is for menu to take controls and keep track of which players are playing...
 menu will also hold and display the game class (which containes board and timer in the future). Menu will start on some sort of home page
 then when you navigate to start a game it will call game class which will call board and timer and so on... menu feeds control inputs to game only
 of the players that are actually playing. others can still spectate however.

 in painter menu will be different for each each person and when they start a game, both them and the other play have the game loaded in a "player" mode
 where their inputs are sent to the game to control the board. If they are not a player it will be a "spectator" mode in which their clicks on the board will
 not be sent to that game. The game will still update when the players that are playing make a move.

 How will painter see the game that wasnt started by a user? a static variable in painter called games[] will hold all games currently running.The spectator's menu
 will open and display the game the player chooses and whenever the timer ticks, or a move is made, it will update in real time for the spectator.
 Updating will occurr by the spectator menu checking if its boardstate is equal to the boardstate of the game in the games[] array. If they differ, it will update
 and redisplay the board. For the timer ig it will also check if the time has changed and if so redisplay the clock.
 
 */
